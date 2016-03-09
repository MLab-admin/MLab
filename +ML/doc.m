function doc(varargin)
% ML.doc Reference page in MLab help browser
%   ML.doc(FCM) displays the documentation of a function, class or method
%   in MLab's help browser. If the browser is already opened, a new tab is
%   created.
%
%   See also doc
%
%   More on <a href="matlab:ML.doc('ML.doc');">ML.doc</a>

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.loc{''} = @(x) ischar(x) || ML.isfunction_handle(x);
in = +in;

% -------------------------------------------------------------------------

clc

% --- Get target
target = ML.which(in.loc)

% --- Parse file
[header, footer] = parse_file(target.path);
H = parse_header(header);
F = parse_footer(footer);

% --- HTML definition

html = '';

switch target.type
    
    case 'class'
        
    case 'method'
        
    case 'mfile'

        % --- Page title
        tmp = regexp(H.h1, '^([^\s]*)\s(.*)', 'tokens');
        add(['<h1>' tmp{1}{1} '</h1>']);
        add(['<div class="subtitle">' tmp{1}{2} '</div>']);
        
        % --- Syntax
        add('<h2>Syntax</h2>');
        for i = 1:numel(H.syntax)
            add(['<div class="syntax">' H.syntax(i).syntax '</div>']);
        end
        
        % --- Description
        add('<h2>Description</h2>');
        for i = 1:numel(H.syntax)
            add(['<p><span class="dsyntax">' H.syntax(i).syntax '</span> ' H.syntax(i).description '</p>']);
        end
        
        % --- Misc
        for i = 1:numel(H.misc)
            add(['<h2>' H.misc(i).type '</h2>']);
            add(['<p>' H.misc(i).description '</p>']);
        end
        
        % --- Doc
        
        % --- See also
        add('<h2>See also</h2>');
        tmp = cell(numel(H.see_also),1);
        for i = 1:numel(H.see_also)
            w = ML.which(H.see_also{i});
            tmp{i} = ['<a/ href="' w.path '">' H.see_also{i} '</a>'];
        end
        add(['<p>' strjoin(tmp, ', ') '</p>'])
        
        
end


% --- Display html
fprintf('%s\n', html);
return

% --- Browser display
tmp = tempname;
fid = fopen(tmp, 'w');
fprintf(fid, html);
fclose(fid);
web(tmp, '-notoolbar');
% web(tmp, '-new', '-notoolbar');

    function add(s)
        html = [html char(10) s];
    end

end

% =========================================================================

% -------------------------------------------------------------------------
function [header, footer] = parse_file(fname)
%parse_file Parse a file
%   [H, F] = parse_file(FNAME) parses FNAME and returns the header H and
%   the footer F.
%
%   See also ML.doc

% --- Get file content
fid = fopen(fname);
tmp = textscan(fid, '%s', 'Delimiter', '\n');
C = deblank(tmp{1});
fclose(fid);

% --- Parse header

% Get header
header = {};
for i = 2:numel(C)
    if isempty(C{i}) || ~strcmp(C{i}(1), '%'), break;
    else, header{end+1} = C{i}; end
end

% --- Parse footer

% Get footer
footer = {};
for i = numel(C):-1:2
    if isempty(C{i}) || ~strcmp(C{i}(1), '%'), break;
    else, footer{end+1} = C{i}; end
end
footer = flipud([footer(:)]);

end

% -------------------------------------------------------------------------
function H = parse_header(header)
%parse_header Parse the header
%   H = parse_header(HEADER) parses HEADER and returns a header structure H
%   containing the following fields:
%       - 'h1'      The first line
%       - 'syntax'  The different syntaxes
%       - 'misc'    Miscellaneous remarks
%
%   See also ML.doc

H = struct('h1', '', 'syntax', struct('syntax', {}, 'description', {}), ...
    'misc', struct('type', {}, 'description', {}), 'see_also', {{}});

% --- H1 line
H.h1 = strtrim(header{1}(2:end));

i = 0;
while true
    
    % Increment
    i = i+1;
    if i>numel(header), break; end
    
    % --- See also
    tmp = regexp(header{i}, '^%\s*See also (.*)', 'tokens');
    if ~isempty(tmp)
        H.see_also = strsplit(tmp{1}{1}, ', ');
        continue
    end
    
    % --- More on ML.doc
    if ~isempty(regexp(header{i}, '^%\s*More on <a href=', 'once'))
        continue;
    end
    
    % Find special characters
    k1 = strfind(header{i}, ')');
    k2 = strfind(header{i}, ':');
    
    % --- Skip empty lines
    if isempty(header{i}(2:end)) || (isempty([k1 k2]))
        continue
    end
    
    % Determine action
    if ~isempty(k1), k1 = k1(1); end
    if ~isempty(k2), k2 = k2(1); end
    
    % --- Syntax entry
    if isempty(k2) || (~isempty(k1) && k1<k2)
        
        % Get syntax paragraph
        P = strtrim(header{i}(2:end));
        while true
            i = i+1;
            if isempty(strtrim(header{i}(2:end))), break; end
            P = [P ' ' strtrim(header{i}(2:end))];
        end
        
        tmp = regexp(P, '^([^\)]*\))(.*)', 'tokens');
        n = numel(H.syntax)+1;
        H.syntax(n).syntax = tmp{1}{1};
        H.syntax(n).description = tmp{1}{2};
        
    end
    
    % --- Misc entry
    if isempty(k1) || (~isempty(k2) && k1>k2)
        
        % Get paragraph
        P = strtrim(header{i}(2:end));
        while true
            i = i+1;
            if i>numel(header) || isempty(strtrim(header{i}(2:end))), break; end
            P = [P ' ' strtrim(header{i}(2:end))];    
        end
        
        tmp = regexp(P, '^([^:]*):\s*(.*)', 'tokens');
        n = numel(H.misc)+1;
        H.misc(n).type = tmp{1}{1};
        H.misc(n).description = tmp{1}{2};
        
    end
    
end

end

% -------------------------------------------------------------------------
function F = parse_footer(footer)
%parse_footer Parse the footer
%   F = parse_footer(FOOTER) parses FOOTER and returns a footer structure F
%   containing the following fields:
%       - 'author'
%       - 'version'
%       - 'revisions'
%       - 'doc'
%
%   See also ML.doc

F = struct('author', '', 'version', '', 'revisions', struct(), 'doc', {{}});

i = 0;
while true
    
    % Increment
    i = i+1;
    if i>numel(footer), break; end
    
    % --- Skip empty lines and decorations
    if isempty(footer{i}(2:end)) || ~isempty(regexp(footer{i}, '^%! -+$', 'once'))
        continue
    end
    
    % --- Author
    tmp = regexp(footer{i}, '^%! Author: (.*)', 'tokens');
    if ~isempty(tmp)
        F.author = tmp{1}{1};
    end
    
    % --- Version
    tmp = regexp(footer{i}, '^%! Version: (.*)', 'tokens');
    if ~isempty(tmp)
        F.version = tmp{1}{1};
    end
    
    % --- Revisions
    n = 0;
    if ~isempty(regexp(footer{i}, '^%! Revisions$', 'once'))
        rev = struct('version', {}, 'date', {}, 'modification', {});
        while true
            i = i+1;
            tmp = regexp(footer{i}, '^%\s*([0-9\.]+)\s*\(([0-9/]+)\):\s+(.*)', 'tokens');
            if isempty(tmp)
                i = i-1;
                break;
            else
                n = n+1;
                rev(n).version = tmp{1}{1};
                rev(n).date = tmp{1}{2};
                rev(n).modification = tmp{1}{3};
            end
                
        end
        F.revisions = rev(end:-1:1);
       
    end
    
    % --- Documentation
    if ~isempty(regexp(footer{i}, '^%! Doc$', 'once'))
        while true
            i = i+1;
            if i>numel(footer), break; end
            F.doc{end+1} = strtrim(footer{i}(2:end));
        end
    end
end

end