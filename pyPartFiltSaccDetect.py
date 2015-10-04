"""
pyPrtFiltSaccDetect.py
program to run a particle filter saccade detector

17dec2014   LMO add timing
"""
import numpy as np
import time as tm

plt=0
try:
    import pyqtgraph as pg
    from pyqtgraph.Qt import QtGui, QtCore
    plt=1
except:
    try:
        import matplotlib.pyplot as mplt
        plt=2
    except:
        print("No supported libraries for plotting")

class PartFiltSaccDetect():
    __classname__ = 'PartFiltSaccDetect'
    def __init__(self, signal=None,PartNum=10,NRepeat=1,StateNoise=[0,0.002],MeasurementNoise=[0,0.005],detectThr=0.0002,resetThr=0.005,doReset=True,removeMedian=True,minGroup=4,deltaGroup=30,deltaBetween=100,reverse=True):
        '''
            Initialize the filter
        '''
        # Initialize the parameter structure of the filter
        self.param={'PartNum':PartNum,'NRepeat':NRepeat,'StateNoise':StateNoise,'MeasurementNoise':MeasurementNoise,
                    'doReset':doReset,'resetThr':resetThr,'detectThr':detectThr,'removeMedian':removeMedian,'minGroup':minGroup,
                    'deltaGroup':deltaGroup,'deltaBetween':deltaBetween,'reverse':reverse,'gainS':None,'gainM':None}

        # If a signal is given at the initialisation of the filter, use it and set the paramters
        self.setSignal(signal)

    def setParamFromSignal(self):
        '''
            Extract the parameters of self.signalIN
        '''
        if self.signalIN is not None:
            self.nSamples=np.shape(self.signalIN)[0]
            self.numSig=np.shape(self.signalIN)[1]

            self.AllEst=np.zeros((self.nSamples,self.numSig,self.param['NRepeat']))
            self.AllPartVar=np.zeros((self.nSamples,self.numSig,self.param['NRepeat']))

            if self.param['gainS'] is None:
                self.param['gainS']=np.ones((self.nSamples,self.numSig))
            else:
                if self.param['reverse']:
                    self.param['gainS']=np.hstack((self.param['gainS'],np.flipud(self.param['gainS'])))

            if self.param['gainM'] is None:
                self.param['gainM']=np.ones((self.nSamples,self.numSig))
            else:
                if self.param['reverse']:
                    self.param['gainM']=np.hstack((self.param['gainM'],np.flipud(self.param['gainM'])))
        else:
            self.nSamples=0
            self.numSig=0
            self.AllEst=0
            self.AllPartVar=0

    def setSignal(self,signal=None):
        '''
            Set the signal to analyze and extract the parameters from the signal.
            self.signal must be a (k,sig) numpy array (k=number of samples, sig=number of signal to apply the filter to)
        '''
        self.signalBase=signal
        self.signalIN=signal
        self.signalOUT=signal

        if self.param['reverse']:
            if signal is not None:
                self.signalIN=np.hstack((self.signalBase,np.flipud(self.signalBase)))
                self.signalOUT=np.hstack((self.signalBase,self.signalBase))

        self.setParamFromSignal()

    def setFilterParam(self,param=None,Value=None):
        '''
            Set the parameters of the filter.
            It can be:
                'PartNum': Number of particles
                'NRepeat': Number of iterations
                'StateNoise': [type, args]
                              type :
                                - 0 -> Gaussian noise with a single parameter representing
                                       the variance of the state for the particle filter.
                                       Example: [0,0.5]
                                - 1 -> Given shape for the probability distribution of
                                       the noise of the state. 2 lists must be given to define
                                       the shape of the distribution. The area under the shape
                                       will be normalized.
                                       Example: [0,[-2.0,-0.5,0.5,2.0],[0,1.0,1.0,0.0]]
                'MeasurementNoise': [type, args]
                              type :
                                - 0 -> Gaussian noise with a single parameter representing
                                       the variance of the measurement error for the particle filter.
                                       Example: [0,0.5]
                                - 1 -> Given shape for the probability distribution of
                                       the noise of the state. 2 lists must be given to define
                                       the shape of the distribution. The area under the shape
                                       will be normalized.
                                       Example: [0,[-2.0,-0.5,0.5,2.0],[0,1.0,1.0,0.0]]
                'doReset': True/False
                'resetThr': Threshold for the reset of the filter
                'removeMedian': Do we remove the median before applying the saccade detection on Upsilon?
                'reverse': reverse the signal to compute in both directions
        '''
        if param in self.param:
            self.param[param]=Value

        # if the parameter is 'reverse' correct the signal accordingly
        if param is 'reverse':
            if Value is True:
                self.setSignal(self.signalBase)

    def comp_oneIteration_par(self,itNum):
        '''
            Compute the iteration itNum of the particle filter on self.signalIN
        '''

        indStart=0
        indEnd=self.nSamples
        for sig in np.arange(0,self.numSig):
            allZero=np.where(self.signalIN[:,sig]!=0.0)[0]
            indSt=allZero[0]
            indEd=allZero[-1]
            if indSt>indStart:
                indStart=indSt
            if indEd<indEnd:
                indEnd=indEd

        # Initialize the variables
        x_est=np.zeros((self.nSamples,self.numSig,self.param['PartNum']))*np.nan
        x_est_var=np.zeros((self.nSamples,self.numSig))*np.nan
        part_weight_var=np.zeros((self.nSamples,self.numSig))*np.nan

        partPos=np.zeros((self.param['PartNum'],self.numSig))
        partPos_up=np.zeros((self.param['PartNum'],self.numSig))
        pos_up=np.zeros((self.param['PartNum'],self.numSig))
        part_weight=np.zeros((self.param['PartNum'],self.numSig))

        np.random.seed()

        # Initialize the particles population
        initPos=indStart
        partPos=np.repeat(np.array([self.signalIN[initPos,:]]),self.param['PartNum'],axis=0)+self.randValue(NPart=[self.param['PartNum'],self.numSig],param=self.param['StateNoise'],doRep=True,gain=self.param['gainS'][initPos,:])

        for sig in np.arange(0,self.numSig):
            AllDefined=np.where(np.isfinite(self.signalIN[:,sig])==1)[0]
            if AllDefined[0]>indStart:
                indStart=AllDefined[0]
            partPos[:,sig]=np.repeat(np.array([self.signalIN[indStart,sig]]),self.param['PartNum'],axis=0)+self.randValue(NPart=[self.param['PartNum']],param=self.param['StateNoise'],doRep=True,gain=self.param['gainS'][initPos,sig])

        # Run the filter
        for tIndex in np.arange(indStart,indEnd):
            partPos_up=partPos+self.randValue(NPart=[self.param['PartNum'],self.numSig],param=self.param['StateNoise'],doRep=True,gain=self.param['gainS'][tIndex,:])
            pos_up = partPos_up

            yepsilon=np.repeat(np.array([self.signalIN[tIndex, :]]), self.param['PartNum'], axis=0) - pos_up
            part_weight = self.densityFunction(yepsilon,param=self.param['MeasurementNoise'],gain=self.param['gainM'][tIndex,:])

            # Resample the particle set
            sumWeight = np.sum(part_weight,axis=0)

            # Convert bad weigths to infinity thus when updating the weights, they will be equal to zero
            badWeights= np.where(((np.isfinite(sumWeight)==False) | (sumWeight==0.0)))[0]
            sumWeight[badWeights]=np.Infinity

            # Computation of the relative likelihood of each particle
            part_weight/=np.repeat([sumWeight],self.param['PartNum'],0)

            # Computation of the cumulative distribution
            cSum_part_weight=np.cumsum(part_weight,axis=0)

            # Add a line to set the zero of the sum and
            # do the same with the updated position of the particles
            cSum_part_weight=np.vstack((np.zeros((1,self.numSig)),cSum_part_weight))
            partPos_up=np.vstack((np.array([partPos_up[0,:]]),partPos_up))

            rTMP=np.random.random((self.param['PartNum'],self.numSig))

            for sig in np.arange(0, self.numSig):
                if (np.isfinite(sumWeight[sig])==True):
                    for partNum in np.arange(0, self.param['PartNum']):
                        partPos[partNum,sig]=partPos_up[np.argmax(rTMP[partNum,sig] <= cSum_part_weight[:,sig]),sig]

            partPos_up=partPos
            x_est[tIndex,:,:]=np.transpose(partPos)
            x_est_var[tIndex,:]=np.var(partPos,axis=0)
            part_weight_var[tIndex,:]=np.var(part_weight,axis=0)

            # If asked for, reset the filter and draw a new population of particles
            if self.param['doReset']:
                for sig in np.arange(0,self.numSig):
                    if (((part_weight_var[tIndex,sig]>self.param['resetThr']) | (np.sum(part_weight_var[tIndex,sig])==0))):
                        x_est[tIndex,sig,:]=np.transpose(np.repeat(np.array([self.signalIN[tIndex,sig]]),self.param['PartNum'],axis=0)+self.randValue(NPart=[self.param['PartNum']],param=self.param['StateNoise'],doRep=True,gain=self.param['gainS'][tIndex,sig]))
                        partPos[:,sig]=np.repeat(np.array([self.signalIN[tIndex,sig]]),self.param['PartNum'],axis=0)+self.randValue(NPart=[self.param['PartNum']],param=self.param['StateNoise'],doRep=True,gain=self.param['gainS'][tIndex,sig])

        outdict = []
        outdict.append(itNum)
        outdict.append(x_est)
        outdict.append(part_weight_var)

        return outdict

    def computeParticleFilter(self,show=False):
        '''
            Apply the particle filter on self.signalIN
        '''
        for itNum in range(self.param['NRepeat']):
            if show:
                print("Do iteration #"+str(itNum+1)+"/"+str(self.param['NRepeat']))
            TMP=self.comp_oneIteration_par(itNum)
            self.AllEst[:,:,itNum]=np.median(TMP[1],axis=2)
            self.AllPartVar[:,:,itNum]=TMP[2]
            if self.param['reverse']:
                self.AllEst[:,(self.numSig/2):,itNum]=np.flipud(self.AllEst[:,(self.numSig/2):,itNum])
                self.AllPartVar[:,(self.numSig/2):,itNum]=np.flipud(self.AllPartVar[:,(self.numSig/2):,itNum])

        # Compute the median value over the iterations for the particles position
        self.Upsilon=np.median(self.AllPartVar,axis=2)

        # Compute the estimated trajectory by the particles
        self.yhat=np.median(self.AllEst,axis=2)

    def densityFunction(self,error=0.0,param=[],gain=1.0):
        '''
         Compute the likelihood of an error
        '''
        if param[0]==0:
            part_weight = (1 / np.sqrt(2 * np.pi* param[1]*gain)) * np.exp(-1.0 * np.power(error, 2.0) / (2.0 * param[1]*gain))
        elif param[0]==1:
            md=np.mean(param[1])
            part_weight = np.zeros_like(error)
            for cl in range(np.shape(error)[1]):
                part_weight[:,cl] = np.interp(error[:,cl],md+(param[1]-md)*gain[cl],param[2])

        return part_weight

    def randValue(self,NPart=[1],param=[],doRep=False,gain=1):
        '''
         Draw a number of random numbers from a distribution (0 for Gaussian distribution, 1 for predefined shape)
        '''
        if param[0]==0:
            var=param[1]
            out=np.reshape(np.random.randn(np.prod(NPart,dtype=int))*np.sqrt(var),tuple(NPart))*np.repeat(np.array([gain]),NPart[0],axis=0)
        elif param[0]==1:
            if doRep:
                nPoints=1000;
                XExtend=np.linspace(param[1][0], param[1][-1], nPoints)
                YExtend=np.interp(XExtend,param[1],param[2])
            else:
                XExtend=np.array(param[1])
                YExtend=np.array(param[2])

            XExtend=gain*(XExtend-np.mean(XExtend))+np.mean(XExtend)

            cumVal=np.cumsum(YExtend)
            cumVal/=cumVal[-1]
            out=np.reshape(np.interp(np.random.random(tuple(NPart)).flatten(),cumVal,XExtend),tuple(NPart))

        return out

    def detectSaccades(self,show=False):
        '''
            Detect saccades
        '''
        # Run the particle filter
        self.computeParticleFilter(show)

        # Remove the median if desired
        self.removeMedian()

        # Find parts of the signal where the Upsilon is larger than the detection threshold
        self.UpsilonAbove=np.zeros_like(self.Upsilon)*np.nan
        if len(self.Upsilon)>0:
            indRaw=[]
            indGroup=[]
            for sig in np.arange(0,self.numSig):
                indRaw.append(np.where(self.Upsilon[:,sig]>=self.param['detectThr'])[0])
                self.UpsilonAbove[indRaw[-1],sig]=self.Upsilon[indRaw[-1],sig]

        if self.numSig==1:
            indRaw=indRaw[0]
        else:
            # If there are several signals, group them, then only take into account the common part of all the signals (AND operator between signals)
            indTMP=[]
            self.UpsilonAbove=np.zeros_like(self.Upsilon)*np.nan
            Cont=0
            for ii in np.arange(0,self.numSig):
                if len(indRaw[ii])>1:
                    indGroup=self.group(np.squeeze(indRaw[ii]),self.param['deltaGroup'],self.param['minGroup'])
                    if len(indGroup)>0:
                        Cont=1
                        indGroup=self.groupInBetween(indRaw[ii],indGroup)
                        SCTMP=np.array([],dtype=int)
                        for hh in np.arange(0,len(indGroup),2):
                            if (indRaw[ii][indGroup[hh]])!=(indRaw[ii][indGroup[hh+1]]):
                                SCTMP=np.hstack((SCTMP,np.arange(indRaw[ii][indGroup[hh]],indRaw[ii][indGroup[hh+1]]+1,1,dtype=int)))

                        self.UpsilonAbove[SCTMP,ii]=self.Upsilon[SCTMP,ii]
                        if isinstance(indTMP,list):
                            indTMP=np.array(SCTMP)
                        else:
                            indTMP=np.intersect1d(indTMP, SCTMP, True)

            if Cont==1:
                indRaw=np.array(indTMP)
            else:
                indRaw=[]

        saccOut=[]
        numSacc=0
        # Group data together
        if len(indRaw)>1:
            indGroup=self.group(np.squeeze(indRaw),self.param['deltaGroup'],self.param['minGroup'])
            indGroup=self.groupInBetween(indRaw,indGroup)
            for ii in np.arange(0,len(indGroup),2):
                if (indRaw[indGroup[ii]])!=(indRaw[indGroup[ii+1]]):
                    saccOut.append({'onset':indRaw[indGroup[ii]],'offset':indRaw[indGroup[ii+1]]})
                    numSacc+=1

        self.saccOut=saccOut
        self.numSacc=numSacc

        self.buildSaccSignal()


    def detectSaccadesSeparate(self,show=False):
        '''
            Detect saccades independently on each signal (or pair of signals if the reverse is set)
        '''
        # Run the particle filter
        self.computeParticleFilter(show)

        # Remove the median if desired
        self.removeMedian()

        # Find parts of the signal where the Upsilon is larger than the detection threshold
        self.UpsilonAbove=np.zeros_like(self.Upsilon)*np.nan
        if len(self.Upsilon)>0:
            indRaw=[]
            indGroup=[]
            UpTMP=np.array(self.Upsilon)
            UpTMP[np.isfinite(UpTMP)==0]=-1000.0
            for sig in np.arange(0,self.numSig):
                indRaw.append(np.where(UpTMP[:,sig]>=self.param['detectThr'])[0])
                self.UpsilonAbove[indRaw[-1],sig]=self.Upsilon[indRaw[-1],sig]

        # Group data together
        saccOut=[]
        numSacc=[]
        for ii in range(np.shape(self.signalBase)[1]):
            numTMP=0
            saccTMP=[]
            if len(indRaw[ii])>1:
                indGroup=self.group(np.squeeze(indRaw[ii]),self.param['deltaGroup'],self.param['minGroup'])
                indGroup=self.groupInBetween(indRaw[ii],indGroup)
                if self.param['reverse']:
                    indGroup2=self.group(np.squeeze(indRaw[ii+self.numSig/2]),self.param['deltaGroup'],self.param['minGroup'])
                    indGroup2=self.groupInBetween(indRaw[ii+self.numSig/2],indGroup2)

                    indTMP1=np.array([],dtype=int)
                    for hh in np.arange(0,len(indGroup),2):
                        indTMP1=np.hstack((indTMP1,np.arange(indRaw[ii][indGroup[hh]],indRaw[ii][indGroup[hh+1]],1,dtype=int)))

                    indTMP2=np.array([],dtype=int)
                    for hh in np.arange(0,len(indGroup2),2):
                        indTMP2=np.hstack((indTMP1,np.arange(indRaw[ii+self.numSig/2][indGroup2[hh]],indRaw[ii+self.numSig/2][indGroup2[hh+1]],1,dtype=int)))

                    indRaw[ii]=np.intersect1d(indTMP1, indTMP2)
                    indGroup=self.group(np.squeeze(indRaw[ii]),self.param['deltaGroup'],self.param['minGroup'])
                    indGroup=self.groupInBetween(indRaw[ii],indGroup)

                for jj in np.arange(0,len(indGroup),2):
                    if (indRaw[ii][indGroup[jj]])!=(indRaw[ii][indGroup[jj+1]]):
                        saccTMP.append({'onset':indRaw[ii][indGroup[jj]],'offset':indRaw[ii][indGroup[jj+1]]})
                        numTMP+=1
            saccOut.append(saccTMP)
            numSacc.append(numTMP)

        self.saccOut=saccOut
        self.numSacc=numSacc

        self.buildSaccSignal()

    def removeMedian(self):
        # Remove the median if desired
        if self.param['removeMedian']:
            for sig in np.arange(0,np.shape(self.Upsilon)[1]):
                tmpY=self.Upsilon[:,sig]
                tmpY = np.ma.masked_invalid(tmpY)
                self.Upsilon[:,sig]-=np.median(tmpY)

    def group(self,data=np.array([[0]]),crit=2,excl=2):
        tmp=np.hstack((data[1:]-data[:-1],crit*5))

        s=np.transpose(np.where(tmp>crit))

        pos=[0]
        t = 1

        for ii in np.arange(0,np.shape(s)[0]):
            if (s[ii]-pos[t-1])>=excl:
                pos=np.append(pos,s[ii])
                t+=1
                pos=np.append(pos,s[ii]+1)
                t+=1
            else:
                pos[t-1]=s[ii]+1

        if ((np.shape(data)[0]-1)-pos[t-1])>=excl:
            pos[t-1]=np.shape(data)[0]-1
        else:
            pos=pos[:-1]

        return pos

    def groupC(self,dataIN=np.array([[0]]),crit=2,excl=2):
        data=np.array(dataIN)
        tmp=np.hstack((data[1:]-data[:-1]))

        cl=0
        if tmp[0]==1:
            data=np.hstack((data[0]-5*excl,data))
            tmp=np.hstack((data[1:]-data[:-1]))
            cl=1

        s=np.nonzero(tmp>crit)[0]
        if len(s)>0:
            if s[-1]<(len(dataIN)-1):
                s=np.hstack((s,np.array([len(dataIN)-1],dtype=int)))
        else:
            pos=np.array([0,len(tmp)-1],dtype=int);
            return pos

        s=np.transpose(s)

        pos=[]

        for ii in np.arange(0,np.shape(s)[0]-1):
            if (data[s[ii+1]]-data[s[ii]+1]+1)>=excl:
                if isinstance(pos,list):
                    pos=np.array([s[ii]+1,s[ii+1]])
                else:
                    pos=np.hstack((pos,np.array([s[ii]+1,s[ii+1]])))

        if not isinstance(pos,list):
            if cl==1:
                pos=pos-1

        return pos


    def groupInBetween(self,rawInd=[],grInd=[]):
        if len(rawInd)>0:
            ii=1
            while (ii<len(grInd)-1):
                if (rawInd[grInd[ii+1]]-rawInd[grInd[ii]])<self.param['deltaBetween']:
                    srFirst=np.abs(self.signalIN[rawInd[grInd[ii-1]]:rawInd[grInd[ii]],:])
                    srSecond=np.abs(self.signalIN[rawInd[grInd[ii+1]]:rawInd[grInd[ii+2]],:])
                    srbt=np.abs(self.signalIN[rawInd[grInd[ii]]:rawInd[grInd[ii+1]],:])
                    mxbt=np.median(srbt)
                    mxft=np.median(srFirst)
                    mxsc=np.median(srSecond)
                    if ((mxbt>mxft) and (mxbt>mxsc)):
                        grInd=np.hstack((grInd[0:ii],grInd[ii+2:]))
                        ii=1
                    else:
                        ii+=2
                else:
                    ii+=2

        return grInd

    def buildSaccSignal(self):
        self.saccSignal=np.nan*np.zeros_like(self.signalOUT)

        if not isinstance(self.numSacc,list):
            indSacc=np.array([],dtype=int)
            for sacc in self.saccOut:
                indSacc=np.hstack((indSacc,np.arange(sacc['onset'],sacc['offset']+1,dtype=int)))

            self.saccSignal[indSacc]=self.signalOUT[indSacc]
        else:
            for ii in range(np.shape(self.signalBase)[1]):
                indSacc=np.array([],dtype=int)
                for sacc in self.saccOut[ii]:
                    indSacc=np.hstack((indSacc,np.arange(sacc['onset'],sacc['offset']+1,dtype=int)))

                if self.param['reverse']:
                    self.saccSignal[indSacc,ii]=self.signalOUT[indSacc,ii]
                    self.saccSignal[indSacc,ii+self.numSig/2]=self.signalOUT[indSacc,ii+self.numSig/2]
                else:
                    self.saccSignal[indSacc,ii]=self.signalOUT[indSacc,ii]


    def computeSimulatedQuality(self,JumpIndex,NoJumpIndex):
        MSETMP=np.mean(np.power(self.yhat-self.signalOUT,2.0),axis=0)
        GTMP=[]

        for ii in range(np.shape(self.signalBase)[1]):
            GTMP.append(np.median(self.Upsilon[JumpIndex[ii],ii])/np.std(self.Upsilon[NoJumpIndex[ii],ii]))

        if self.param['reverse']:
            for ii in range(np.shape(self.signalBase)[1]):
                GTMP.append(np.median(self.Upsilon[JumpIndex[ii],ii+np.shape(self.signalBase)[1]])/np.std(self.Upsilon[NoJumpIndex[ii],ii+np.shape(self.signalBase)[1]]))

        self.MSE=np.array([MSETMP[0:np.shape(self.signalBase)[1]],MSETMP[np.shape(self.signalBase)[1]:]])
        self.G=np.array([GTMP[0:np.shape(self.signalBase)[1]],GTMP[np.shape(self.signalBase)[1]:]])

#########################################################################################################################
if __name__ == '__main__':
    startTime = tm.time();
    
    # create a dummy data test for the detection filter with a single cycle of target motion and a noise added to the signal
    dt=0.001
    time=np.arange(0,0.55,dt)
    y=np.array([1.0*np.sin(2*np.pi*time)]).T

    # print 'time.shape', time.shape

    # Add an event at time tJump for a duration dur
    AmpJump=0.5
    tJump=0.05
    dur=0.02

    tCycleJump=int(tJump/dt)
    durJump=int(dur/dt)
    halfCycle=np.floor(durJump/2)

    yJump=np.arange(0,durJump,dtype=float)
    yJump[0:(halfCycle+1)]*=AmpJump/halfCycle
    yJump[(halfCycle):]=yJump[halfCycle]-AmpJump/halfCycle*np.arange(0,halfCycle,dtype=float)

    y[tCycleJump:(tCycleJump+durJump),:]+=np.repeat(np.array([yJump]).T,np.shape(y)[1],axis=1)

    # Add a noise with an amplitude linked to the amplitude of the signal
    rangeAngle=45.0;
    factor=rangeAngle/np.max(y)
    yn=np.random.randn(np.shape(y)[0],np.shape(y)[1])*(0.15*(1-np.abs(np.cos(y*factor*np.pi/180.0)))+0.015)+0.03*np.sin(2*np.pi*17.5*np.repeat(np.array([time]).T,np.shape(y)[1],axis=1))

    y+=yn

    # Add a blink in the signal
    tBl=0.2
    dBl=0.025

    inOnBl=int(tBl/dt)
    durOnBl=int(dBl/dt)

    y[inOnBl:(durOnBl+inOnBl),:]=-50.0


    #print y.shape
    #print type(y)


    filtTest=PartFiltSaccDetect()

    filtTest.setFilterParam('PartNum', 200)
    filtTest.setFilterParam('NRepeat', 10)
    filtTest.setFilterParam('StateNoise', [0,0.003])
    filtTest.setFilterParam('MeasurementNoise', [1,[-0.2,-0.04,0.04,0.2],[0,1,1,0]])
    filtTest.setFilterParam('detectThr', 0.0000025)
    filtTest.setFilterParam('resetThr', 0.005)
    filtTest.setFilterParam('deltaBetween', 8)
    filtTest.setFilterParam('deltaGroup', 8)
    filtTest.setFilterParam('minGroup', 8)
    filtTest.setFilterParam('reverse', True)
    filtTest.setFilterParam('gainM', 1+(np.abs(np.sin(y*factor*np.pi/180.0))))


    filtTest.setSignal(y)


    filtTest.detectSaccades()

    if plt==1: # Plot using pyqtgraph
        print("plot with pyqtgraph")
        app = QtGui.QApplication([])
        win = pg.GraphicsWindow()
        vb1=pg.ViewBox()
        vb2=pg.ViewBox()
        p1=win.addPlot(viewBox=vb1, col=0, row=0)
        p1.setLabel('bottom', 'Time', units='s')
        p2=win.addPlot(viewBox=vb2, col=0, row=1)
        p2.setLabel('bottom', 'Time', units='s')
        vb2.setXLink(p1)
        for sig in range(filtTest.numSig):
            vb1.addItem(pg.PlotCurveItem(x=time, y=filtTest.signalOUT[:,sig],pen=(sig,filtTest.numSig*2),connect='finite'))
            vb1.addItem(pg.PlotCurveItem(x=time, y=filtTest.yhat[:,sig],pen=(sig+filtTest.numSig,filtTest.numSig*2),connect='finite'))
            vb1.addItem(pg.PlotCurveItem(x=time, y=filtTest.saccSignal[:,sig],pen=pg.mkPen(color=(sig,filtTest.numSig*2),width=3),connect='finite'))
            vb2.addItem(pg.PlotCurveItem(x=time, y=filtTest.Upsilon[:,sig],pen=(sig+filtTest.numSig,filtTest.numSig*2),connect='finite'))
            vb2.addItem(pg.PlotCurveItem(x=time[[0,(len(time)-1)]], y=np.array([filtTest.param['detectThr'],filtTest.param['detectThr']]),pen=pg.mkPen(color=(255,0,0),width=3),connect='finite'))
            vb2.addItem(pg.PlotCurveItem(x=time, y=filtTest.UpsilonAbove[:,sig],pen=pg.mkPen(color=(0,255,0),width=3),connect='finite'))
        p1.setYRange(-1.0,2.0)
        QtGui.QApplication.exec_()
    elif plt==2: # Plot using matplotlib
        mplt.figure(1)
        ax=mplt.subplot(211)
        bx=mplt.subplot(2,1,2,sharex=ax)
        for sig in range(filtTest.numSig):
            ax.plot(time, filtTest.signalOUT[:,sig], time,filtTest.yhat[:,sig], time,filtTest.saccSignal[:,sig],'bo')
            bx.plot(time, filtTest.Upsilon[:,sig], time[[0,(len(time)-1)]],np.array([filtTest.param['detectThr'],filtTest.param['detectThr']]), time,filtTest.UpsilonAbove[:,sig],'bo')
        mplt.show()
        print("plot using matplotlib")
    else:
        print("Do not plot any data")

    print ("Elapsed time: %5.3f s" % (tm.time() - startTime))
 