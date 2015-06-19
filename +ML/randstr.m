function out = randstr(varargin)
%ML.randstr Random strings.
%   S = ML.randstr() Creates a random string S of 6 characters.
%
%   S = ML.randstr(N) returns a random string with N characters.
%
%   ML.randstr(..., 'alphabet', ALPHA) uses only characters from the 
%   alphabet ALPHA. ALPHA can be a string or cell of strings, and 
%   characters can be repeated to increase their probability. The default 
%   alphabet is [A... Z a ...z].
%
%   ML.randstr(..., 'type', TYPE) alternatively, you can specify the type 
%   of random string you want. TYPE can be:
%       - 'variable': generates a valid variable name (Matlab identifier)
%       - 'field':    generates a valid structure field name
%
%   Note that the default alphabet is also suitable to generate random
%   variables or structure field names.
%
%   See also rand, matlab.lang.makeValidName,
%   matlab.lang.makeUniqueStrings, namelengthmax, isvarname
%
%   More on <a href="matlab:ML.doc('ML.randstr');">ML.doc</a>

% --- Inputs
in = ML.Input;
in.length{6} = @isnumeric;
in.alphabet(char([65:90 97:122])) = @(x) ischar(x) || iscellstr(x);
in.type('default') = @(x) any(strcmpi(x, {'default', 'variable', 'field'}));
in = +in;

% --- Checks
if in.length==0
    out = '';
    return
end

if in.length<0 || isnan(in.length) || ~isfinite(in.length)
    warning('ML:randstr:InvalidStrLength', 'Invalid string length specified, using default value (6)');
    in.length = 6;
end

if any(strcmpi(in.type, {'variable', 'field'})) && in.length>namelengthmax 
    warning('ML:randstr:MaxStrLength', ['The string length is too high, using maximum possible (' num2str(namelengthmax) ')']);
    in.length = namelengthmax;
end

% --- Processing

switch lower(in.type)
    
    case {'variable', 'field'}
                
        A = char([65:90 97:122]);
        B = char([48:57 65:90 95 97:122]);
        out = [A(randi(numel(A))) B(randi(numel(B), [1 in.length-1]))];
                
    otherwise
        
        out = in.alphabet(randi(numel(in.alphabet), [1 in.length]));
        if iscell(out)
            out = cell2mat(out);
        end
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/08): Created help, added the 'type' options and the
%               possibility to use a cell for the alphabet. Improved
%               checking section.
%   1.0     (2012/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>