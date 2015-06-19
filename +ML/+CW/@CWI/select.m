function select(this, varargin)
%ML.CW.CWI/select Selectable list
%   ML.CW.CWI/select(I, J, LIST) adds a selectable list containing the 
%   options listed in LIST at position (I,J) in the grid. LIST can be a 
%   number, a string, a numeric array or a cell containing only numbers and 
%   strings.
%
%   ML.CW.CWI/select(..., 'values', V) specifies an array of initial values
%   V. V can be a numerical or logical array.
%
%   ML.CW.CWI/mode(..., 'mode', M) specifies the selection mode. Possible
%   values for M are:
%       - 'single' (default):  Zero or one option can be selected
%       - 'multiple', 'multi': Any number of option can be selected
%
%   ML.CW.CWI/select(..., 'desc', TXT) adds a textual description TXT on 
%   top of the list during display.
%
%   ML.CW.CWI/select(..., 'symbols', S) specifies checking symbols. S is a
%   two element cell, whose first (resp. second) element is displayed for 
%   the 'false' (resp. 'true') state. The elements of S can have multiple
%   characters.
%
%   See also ML.CW.CWI, ML.CW.CWI/text, ML.CW.CWI/input, ML.CW.CWI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI.select');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.list = @(x) ischar(x) || isnumeric(x) || iscell(x);
in.values([]) = @(x) islogical(x) || isnumeric(x);
in.mode('single') = @(x) any(strcmpi(x, {'single', 'multi', 'multiple'}));
in.desc('') = @ischar;
in.symbols({char(9633) char(9641)}) = @iscell;
in = +in;

% --- Checks

% List
if ~iscell(in.list)
    if isnumeric(in.list) && numel(in.list)>1
        in.list = mat2cell(in.list, 1, ones(numel(in.list),1));
    else
        in.list = {in.list};
    end
end

I = cellfun(@isnumeric, in.list);
in.list(I) = cellfun(@num2str, in.list(I), 'UniformOutput', false);

% Velues
if isnumeric(in.values)
    in.values = logical(in.values);
end

if isempty(in.values)
    in.values = zeros(numel(in.list),1);
end

% Mode
if strcmp(in.mode, 'multi')
    in.mode = 'multiple';
end

% --- Store
this.elms{in.row, in.col} = struct('type', 'select', ...
    'desc', in.desc, ...
    'list', {in.list}, ...
    'values', in.values, ...
    'mode', in.mode, ...
    'symbols', {in.symbols});

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Improved conversion from numerals to logicals for
%               'values' and from numeral to strings for 'list', added the
%               possibility to input a numerical array for 'list'.
%   1.0     (2015/04/06): Initial version.
%
%! To do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>