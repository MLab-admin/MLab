function add(this, varargin)
%ML.CW.CLI/add Add option to CLI page
%   ML.CW.CLI/add(KEY, DESC, ACTION) adds an option identified with the
%   shortcut KEY and the description DESC. ACTION is a string or a function
%   handle refering to a method of the class. Callbacks are called without 
%   any parameter.
%
%   See also ML.CW.CLI, ML.CW.CLI/define
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.add');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.key = @(x) ischar(x) || isnumeric(x);
in.desc = @ischar;
in.action = @ML.isfunction_handle;
in = +in;

i = numel(this.elms)+1;
this.elms(i).key = in.key;
this.elms(i).desc = in.desc;
this.elms(i).action = func2str(in.action);

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.0
%
%! Revisions
%   1.0     (2015/04/07): Created help.
%   1.0     (2015/04/02): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>