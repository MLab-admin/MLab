function action(this, varargin)
%ML.CW.CWI/action Clickable element (action triger)
%   ML.CW.CWI/action(I, J, DESC, ACTION) adds a clickable link at position 
%   (I,J) in the grid. The text of the link is specified by the string
%   DESC. ACTION can be either a string or a function handle, but in both
%   cases they refer to a method of the class that will be called as a
%   parameterless callback.
%
%   See also ML.CW.CWI, ML.CW.CWI/text, ML.CW.CWI/input, ML.CW.CWI/select
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI.action');">ML.doc</a>

% --- Input
in = ML.Input;
in.row = @isnumeric;
in.col = @isnumeric;
in.desc = @ischar;
in.action = @(x) ischar(x) || ML.isfunction_handle(x);
in = +in;

% --- Check
if ML.isfunction_handle(in.action)
    in.action = func2str(in.action);
end

if isempty(in.desc)
    warning('ML:CW:CWI:action:NoDescription', 'The description of an action element cannot be empty.')
    in.desc = '-';
end

% --- Store
this.elms{in.row, in.col} = struct('type', 'action', ...
    'desc', in.desc, ...
    'action', in.action);

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