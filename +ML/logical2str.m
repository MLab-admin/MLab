function out = logical2str(b)
%ML.logical2str Logical to string conversion
%	S = ML.logical2str(B) converts the logical number B into the output
%   string S, which can be either 'true' or 'false'.
%
%   See also num2str
%
%   More on <a href="matlab:ML.doc('ML.logical2str');">ML.doc</a>

% --- Inputs
in = ML.Input(b);
in.addRequired('b', @islogical);
in = +in;

% --- Processing

if in.b
    out = 'true';
else
    out = 'false';
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/08): Created help.
%   1.0     (2010/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>