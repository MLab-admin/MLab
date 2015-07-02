function config(varargin)
%ML.config MLab configuration
%
%   See also ML.start.
%

% --- Inputs
in = ML.Input;
in.menu{'main'} = @ischar;
in = +in;

if ~ML.isdesktop
    ML.Config.CLI(in.menu);
else
    ML.Config.CWI(in.menu);
end