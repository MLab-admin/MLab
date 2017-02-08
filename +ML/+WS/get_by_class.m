function out = get_by_class(varargin)
%ML.WS.get_by_class List variables of a given class
%   OUT = ML.WS.get_by_class(CLASS) where CLASS is a valid class name
%   returns a cell containing the names of the variables belonging to this
%   class in the current workspace.
%
%   OUT = ML.WS.get_by_class(..., 'WorkSpace', WS) specifies the workspace.
%   WS can be either 'base' (default) or 'caller'.
%
%   See also whos
%
%   More on <a href="matlab:ML.doc('ML.WS.get_by_class');">ML.doc</a>

% --- Inputs

in = ML.Input;
in.class = @ischar;
in.workspace('base') = @(x) ismember(x,{'base', 'caller'});
in = +in;

% --- Get the output
W = evalin(in.workspace, 'whos');
out = {W(ismember({W.class}, in.class)).name};

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/02): Created help and improved input support
%   1.0     (2015/01/01): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>