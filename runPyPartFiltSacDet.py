""" read matlab file, pyInData.txt, run pyPartFiltSaccDetect,
and write output into pyOutData.txt
Columns are:
time
signalOUT(1)
yhat(1)
saccSignal(1)
Upsilon(1)
UpsilonAbove(1)
signalOUT(2)
yhat(2)
saccSignal(2)
Upsilon(2)
UpsilonAbove(2)

where 1 = forward and 2 = reverse filtering.

16dec2014   LMO create
17dec2014   LMO change parameters to detect saccades in PD patients
"""
import numpy as np
from optparse import OptionParser
from pyPartFiltSaccDetect import PartFiltSaccDetect

def main():
    # get input args
    usemsg = "usage: %prog inputFileName"
    parser = OptionParser(usemsg)

    (options, args) = parser.parse_args()
    if len(args) != 1:
        parser.error("Incorrect number of arguments")
    filename = args[0]
    #print "input filename = %s" % filename
    ofilename = filename + "o"
    #print "output filename = %s\n" % ofilename
    
    # load data
    y = np.loadtxt(filename);
    y = y.reshape((len(y), 1))

    # create filter
    PF=PartFiltSaccDetect()

    PF.setFilterParam('PartNum', 50) # num particles, could be as low 50, as hi as 200 (paired with NRepeat)
    PF.setFilterParam('NRepeat', 5) # should be 5-10
    PF.setFilterParam('StateNoise', [0,0.003]) # was [0, 0.003]
    PF.setFilterParam('MeasurementNoise', [0, 0.003]) # was [1,[-0.2,-0.04,0.04,0.2],[0,1,1,0]]
    PF.setFilterParam('detectThr', 5e-5) # could be as small as 2.5e-6, detectThr goes up as PartNum goes down
    PF.setFilterParam('resetThr', 5e-3) # nominally 5e-3
    PF.setFilterParam('deltaBetween', 20) # should be ~ 100 steps, was 8
    PF.setFilterParam('deltaGroup', 30) # the min steps within a group, was 8
    PF.setFilterParam('minGroup', 8) # the min size of a group in steps
    PF.setFilterParam('reverse', True)
    factor = 45.0
    PF.setFilterParam('gainM', 1+(np.abs(np.sin(y*factor*np.pi/180.0))))

    PF.setSignal(y)

    PF.detectSaccades()

    # save data
    time=np.arange(0,len(y),1)/1000.0
    np.savetxt(ofilename, (time,
        PF.signalOUT[:,0], PF.yhat[:, 0], PF.saccSignal[:,0], PF.Upsilon[:,0], PF.UpsilonAbove[:,0],
        PF.signalOUT[:,1], PF.yhat[:, 1], PF.saccSignal[:,1], PF.Upsilon[:,1], PF.UpsilonAbove[:,1]), fmt='%1.18e')
        
if __name__ == '__main__':
    main()