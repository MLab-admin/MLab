function txt = fetch(varargin)
%ML.Internal.fetch Fetch information on MLab sevrer
%   TXT = ML.NET.URL2TXT(URL) returns the text fetched at URL.
%
%   TXT = ML.NET.URL2TXT(..., 'error', false) generates a warning instead 
%   of an error if the URL could not be read.
%
%   TXT = ML.NET.URL2TXT(..., 'delimiter', DEL) uses a custom set of
%   delimiters. DEL can be either a string (e.g. '\n') or a cell of strings
%   (default: {'\n', '\r'}).
%  
%   Reference page in Help browser: <a href="matlab:doc ML.Net.url2txt">doc ML.Net.url2txt</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% --- Inputs

in = ML.Input;
in.url = @ischar;
in.error(true) = @islogical;
in.delimiter({'\n','\r'}) = @(x) iscellstr(x) || ischar(x);
in = +in;

% =========================================================================

[tmp, status] = urlread(in.url, 'Charset','UTF-8');

if ~status
    s = 'Could not connect to the MLab server. You should check that 1) your internet connection is working and 2) that the MLab website is active.';
    if in.error
        error('MLab:Version', s);
    else
        warning('MLab:Version', s);
    end
end

% --- Output
if isempty(tmp)
    txt = '';
else
    tmp = textscan(tmp, '%s', 'delimiter', in.delimiter);
    txt = tmp{1};
end