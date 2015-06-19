function text(this, varargin)
%ML.CW.CWI/text Text element
%   ML.CW.CWI/text(I, J, TEXT) adds a text element containing the string
%   TEXT at position (I,J) in the grid.
%
%   See also ML.CW.CWI, ML.CW.CWI/input, ML.CW.CWI/select, ML.CW.CWI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI.text');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.text = @ischar;
in = +in;

% --- Store
this.elms{in.row, in.col} = struct('type', 'text', 'text', in.text);

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help.
%   1.0     (2015/04/06): Initial version.
%
%! To do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>