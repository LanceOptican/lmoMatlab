%FINDML (find matlab) searches the whole matlab tree using regular expressions or any file extension
% 
%Examples 
%        findml .tlc .tmf xpc                  % find .tlc .tmf files with "xpc" in name
%        findml xpc.*conf xpc.*setup xpc.*init % find xpc releated setup commands
%        findml --help                         % gives you more details and some examples
%
%FINDML is just a matlab shell around UNIX shell (sh) script findml.sh.
%which is expected at /usr/local/bin. Change sh_cmd in findml.m if this is not true.
%
%If you still use a DOS box, findml assumes that you use CYGWIN (http://sources.redhat.com/cygwin/)
%as an UNIX environment for Windos. In this case, open findml.m and also check CYGWIN_ROOT .  
%
%Comments are welcome. 
%                                                                vdenneberg@mathworks.de  


function findml(varargin)

sh_cmd=['sh /usr/local/bin/findml.sh '];  % <-------------- check path ! always UNIX syntax

for a=1:1:length(varargin)
    sh_cmd=[ sh_cmd ' ' varargin{a} ];
end


if ispc
    
%     CYGWIN_ROOT='c:\bin\cygwin';          % <-------------- check path ! DOS syntax here
    CYGWIN_ROOT='c:\cygwin';          % <-------------- check path ! DOS syntax here

    cmd=['SET PATH=' CYGWIN_ROOT '\usr\local\bin;' CYGWIN_ROOT '\bin;%SYSTEMROOT%\system32;%SYSTEMROOT% && ' sh_cmd ];
    cmd
else 
    cmd=sh_cmd;
end

[exitcode,text] = system(cmd);

disp(text);