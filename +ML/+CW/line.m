function out = line(varargin)
%ML.CW.line Line display
%   ML.CW.LINE() prints a hotizontal line filling the command window.
%
%   ML.CW.LINE(TXT) prints a horizontal line with the string TXT.
%
%   ML.CW.LINE(TXT, ..., 'marker', M) uses the character M to fill the 
%   line. The marker has to be a single character string.
%
%   Tip: Use char(9473) to make a bold line.
%
%   ML.CW.LINE(TXT, ..., 'length', LEN) specifies the total number of
%   characters to display in the line. The default behavior is to fill the 
%   command window horizontally.
%
%   OUT = ML.CW.LINE(...) returns the line without printing it.
%
%   See also fprintf, disp
%
%   More on <a href="matlab:ML.doc('ML.CW.line');">ML.doc</a>

% --- Inputs

in = ML.Input;
in.str{''} = @ischar;
in.marker(char(9472)) = @(s) ischar(s) && numel(s)==1;
in.length(NaN) = @isnumeric;
in = +in;

% --- Get default length
if isnan(in.length)
    tmp = get(0,'CommandWindowSize');
    in.length = tmp(1);
end

% --- Compute the line

% Initialization
txt = '';

% Add text
if ~isempty(in.str)
    txt = [in.marker in.marker ' ' in.str ' '];
end

% Finish line
N = ML.CW.numel(txt);
txt = [txt repmat(in.marker, [1,in.length-N-1]) char(10)];               

% --- Output
if nargout
    out = txt;
else
    ML.CW.print(txt); 
end