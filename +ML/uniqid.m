function out = uniqid(varargin)
%ML.uniqid Unique identifiers
%   UID = ML.uniqid() creates a unique string identifier UID, composed of
%   the date and time with millisecond precision.
%
%   UID = ML.uniqid(N) returns a N-by-1 cell of unique string identifiers.
%
%   See also datestr, now
%
%   More on <a href="matlab:ML.doc('ML.uniqid');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.n{1} = @isnumeric;
in = +in;

if in.n==1

    % --- Single output
    out = datestr(now,'yyyymmddHHMMSSFFF');
    
else
    
    % --- Multiple output
    out = cell(in.n, 1);
    for i = 1:in.n
        while true
            tmp = datestr(now,'yyyymmddHHMMSSFFF');
            if i==1 || ~strcmp(tmp, out{i-1})
                out{i} = tmp;
                break;
            end
        end
    end
    
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help, improved accuracy for multiple
%               outputs.
%   1.0     (2013/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>TO DO</title>