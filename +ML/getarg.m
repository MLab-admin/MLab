function out = getarg(varargin)
%ML.getarg Argument value
%   V = ML.getarg(C, PARAM) returns the value of PARAM in the key/value
%   cell C. PARAM can be either a string or a cell of string. In the later
%   case, V is also a cell.
%
%   ML.getarg(..., 'CaseSensitive', false) parses the parameter cell
%   cese-insensitively.
%
%   ML.getarg(..., 'default', D) specifies the value to return if the
%   parameter is not found. The default value is a NaN.
%   
%   See also ML.Input, varargin
%
%   More on <a href="matlab:ML.doc('ML.getarg');">ML.doc</a>

% --- Inputs

in = ML.Input;
in.cell = @iscell;
in.arg = @(x) ischar(x) || iscellstr(x);
in.CaseSensitive(true) = @islogical;
in.default(NaN) = @(x) true;
in = +in;

% --- Cellification
if ischar(in.arg)
    in.arg = {in.arg};
end

% --- Computation
pos = 1:2:numel(in.cell);
if in.CaseSensitive
    tmp = cellfun(@(x) strcmp(x, in.cell(pos)), in.arg, 'UniformOutput', false);
else
    tmp = cellfun(@(x) strcmpi(x, in.cell(pos)), in.arg, 'UniformOutput', false);
end
   
% --- Output
for i = 1:numel(tmp)
    if any(tmp{i})
        out{i} = in.cell{pos(find(tmp{i},1,'first'))+1};
    else
        out{i} = in.default;
    end
end

% Single output case
if numel(out)==1
    out = out{1};
end
    
%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help, handled multiple inputs.
%   1.0     (2011/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>Custom title</title>