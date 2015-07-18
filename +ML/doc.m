function T = doc(varargin)
% ML.doc Reference page in MLab help browser
%   ML.doc('ok') This is bla bla bla bla.

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.loc{''} = @(x) ischar(x) || ML.isfunction_handle(x);
in = +in;

% -------------------------------------------------------------------------

target = ML.Internal.which(in.loc);

% --- Output
if nargout
    
    T = target;
    
else

    % D = ML.Doc.R2014b
    
end

return

if isempty(in.file)
    
    S = struct();
    html = ML.Doc.html_R2014a(S, 'title', 'Test');
    
else
    
    
    
    
    
    % --- Locate file
    fname = which(in.file);
    
    % --- Parse file
    fid = fopen(fname);
    tmp = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    C = tmp{1};
    S = struct('filename', fname);
    cs = '';
    
    for i = 1:numel(C)
        
        % Remove trailing spaces
        line = deblank(C{i});
        
        % Comments
        if numel(line)<2 || numel(line)>7 && strcmp(line(1:8), '%! -----')
            continue
        end
        
        % New section
        if numel(line)>3 && strcmp(line(1:3), '%! ')
            
            tmp = regexp(line(4:end), '([^:]*):?(.*)', 'tokens');
            section = tmp{1}{1};
            if ~isempty(tmp{1}{2})
                S.(section) = tmp{1}{2};
                cs = '';
            else
                cs = section;
            end
            continue
        end
        
        % Current section
        if ~isempty(cs)
            if ~isfield(S, cs)
                S.(cs) = strtrim(line(2:end));
            else
                S.(cs) = [S.(cs) char(10) strtrim(line(2:end))];
            end
        end
    end
    
    % --- Prepare HTML
    html = ML.Doc.html_R2014a(S, 'title', in.file);
    
end

% --- Display html
% fprintf(html);
% fprintf('\n');
% return

% --- Browser display
tmp = tempname;
fid = fopen(tmp, 'w');
fprintf(fid, html);
fclose(fid);
web(tmp, '-notoolbar');
% web(tmp, '-new', '-notoolbar');

% -------------------------------------------------------------------------
    function add(txt)
        html = [html char(10) txt];
    end
end
