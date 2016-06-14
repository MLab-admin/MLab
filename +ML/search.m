function OUT = search(varargin)
%ML.search Locate functions, packages, classes, methods and more
%   ML.search(NAME) displays information on the script, function, package,
%   class, method or MLab item (MLab, plugin or tutorial) designated by the
%   entity NAME. NAME can be a string or a function handle.
%
%   ML.search(..., 'all') displays information on all items designated by
%   the entity NAME. The first entry is the one that is accessible in the
%   path, the others are shadowed. The syntax '-all' is also accepted for
%   compatibility with Matlab's <a href="matlab:doc which">which</a> function.
%
%   ML.search(..., 'notfound', NFP) uses a custom "not found procedure". 
%   NFP is a string which can be:
%       - 'none': Nothing is done
%       - 'info': A message is displayed in the command window
%       - 'warning': (default) A warning is thrown
%       - 'error': An error is thrown
%
%   out = ML.search(...) returns a ML.Search-dreived object, or a cell of 
%   ML.Search-derived objects if the 'all' option is invoked.
%
%   See also which, lookfor, exist

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.req = @(x) ischar(x) || isa(x, 'function_handle');
in.what{'one'} = @(x) ismember(x, {'one', 'all', '-all'});
in.notfound('warning') = @(x) ismember(x, {'none', 'info', 'warning', 'error'});
in.verbose(true) = @islogical;
in = +in;

% --- Definitions ---------------------------------------------------------

% --- Pathes

% Toolboxes
tpath = [matlabroot filesep 'toolbox' filesep];

% MLab & plugins
conf = ML.config;
ppath = [conf.path 'Plugins' filesep];

% --- Output
isnotfound = false;
out = {};

% --- Checks --------------------------------------------------------------

% Manage function handles
if isa(in.req, 'function_handle')
    in.req = func2str(in.req);
end

% Empty request
if isempty(in.req)
    warning('ML:which', 'Empty input.');
    return
end

% -all compatibility
if strcmp(in.what, '-all')
    in.what = 'all';
end

% --- Type ----------------------------------------------------------------

% Use which as an input
if strcmp(in.what, 'all')
    path = which(in.req, '-all');    
else
    path = {which(in.req)};
end

for i = 1:numel(path)

    % Preparation
    info = struct('type', '', 'category', '');
    
    if ~isempty(path{i})      % ::: File or class :::::::::::::::::::::::::

        % --- Category

        if regexp(path{i}, '^built-in \(.*\)', 'once')

            % Built-in
            info.category = 'Built-in';

            % Redefine path
            tmp = regexp(path{i}, '^built-in \((.*)\)', 'tokens');
            path{i} = tmp{1}{1};

        elseif strfind(path{i}, [tpath 'matlab' filesep])

            % Matlab
            info.category = 'Matlab';

        elseif strfind(path{i}, tpath)

            % Toolbox
            info.category = 'Toolbox';
            x = path{i}(numel(tpath)+1:end);
            info.toolbox = x(1:strfind(x, filesep)-1);

        elseif strfind(path{i}, ppath)
            
            info.category = 'Plugin';
            x = path{i}(numel(ppath)+1:end);
            info.plugin = x(1:strfind(x, filesep)-1);
            
        elseif strfind(path{i}, conf.path)
            
            info.category = 'MLab';
            
        else

            % User
            info.category = 'User';

        end

        % --- Type

        if strfind(path{i}, [filesep '@'])

            % --- Class
            info.type = 'class';
            path{i} = fileparts(path{i});

        elseif ismember(path{i}(end-1:end), {'.m', '.p'})

            % --- Script or function ?
            try
                nargin(path{i});
                info.type = 'Function';
            catch EX
                if strcmp(EX.identifier, 'MATLAB:nargin:isScript')
                    info.type = 'Script';
                else
                    rethrow(EX);
                end
            end

        else
            info.type = 'Function';
        end

    else                    % ::: Package or method :::::::::::::::::::::::

        p = meta.package.fromName(in.req);

        if ~isempty(p)      % ::: Package :::

            % --- Type
            info.type = 'Package';

            % --- Path
            I = strfind(p.Name, '.');
            if isempty(I)
                tmp = what(p.Name);
                for j = 1:numel(tmp)
                    path{i} = tmp(j).path;
                    if exist(path{i}, 'dir'), break; end
                end
            else
                epath = ['+' strrep(p.Name, '.', [filesep '+'])];
                tmp = what(p.Name(1:I(1)-1));
                for j = 1:numel(tmp)
                    path{i} = [tmp(j).path(1:end-I(1)) epath];
                    if exist(path{i}, 'dir'), break; end
                end
            end

            % --- Category
            if strfind(path{i}, [tpath 'matlab' filesep])

                % Matlab
                info.category = 'Matlab';

            elseif strfind(path{i}, tpath)

                % Toolbox
                info.category = 'Toolbox';
                x = path{i}(numel([matlabroot filesep 'toolbox' filesep])+1:end);
                info.toolbox = x(1:strfind(x, filesep)-1);

            else

                % User
                info.category = 'User';

            end

        else                % ::: Method (or junk) :::

            % Check for junk
            k = find(in.req=='.', 1, 'last');
            if isempty(k) || isempty(which(in.req(1:k-1)))
                isnotfound = true;
            else

                % Class & category
                cls = ML.search(in.req(1:k-1));
                info.class = cls.location;
                info.category = cls.category;

                % Path
                if exist([cls.location.fullpath filesep in.req(k+1:end) '.m'], 'file')
                    path{i} = [cls.location.fullpath filesep in.req(k+1:end) '.m'];
                elseif exist([cls.location.fullpath filesep in.req(k+1:end) '.p'], 'file')
                    path{i} = [cls.location.fullpath filesep in.req(k+1:end) '.p'];
                else
                    isnotfound = true;
                end

                if ~isnotfound
                    if strcmp(path{i}(end-1:end), '.m')
                        info.type = 'method:mfile';
                    elseif strcmp(path{i}(end-1:end), '.p')
                        info.type = 'method:pfile';
                    end
                end
            end
        end

    end
    
    % --- Nothing found ---------------------------------------------------

    if isnotfound

        if nargout
            OUT = struct();
        else
            switch in.notfound
                case 'info'
                    fprintf('Could not find anything for ''%s''.\n', in.req);
                case 'warning'
                    warning('Which::NotFound', ['Could not find anything for ''' in.req '''.']);
                case 'error'
                    error('Which::NotFound', ['Could not find anything for ''' in.req '''.']);
            end
        end

        return
    end
    
    % --- Containing package ----------------------------------------------
    
    str = fileparts(path{i});
    I = strfind(str, [filesep '+']);
    tmp = cell(numel(I), 1);
    for j = 1:numel(I)
        if j<numel(I)
            tmp{j} = str(I(j)+2:I(j+1)-1);
        else
            tmp{j} = str(I(j)+2:end);
        end
    end
    if ~isempty(tmp)
        info.package = strjoin(tmp, '.');
    end
    
    
    % info.package
    
    % --- ML.Search objects -----------------------------------------------
        
    switch info.type
        
        case 'Function'
            out{i} = ML.Search.Function(path{i}, 'info', info);
        
        case 'Script'
            out{i} = ML.Search.Script(path{i}, 'info', info);
            
        case 'Package'
            out{i} = ML.Search.Package(path{i}, 'info', info);
            
        otherwise
            info
    end

end

% --- Output & display ----------------------------------------------------

if nargout
    
    if strcmp(in.what, 'all')
        OUT = out;
    else
        OUT = out{1};
    end
    
else
    
    if in.verbose
        fprintf('\n');
        ML.CW.line(['Search Results for ''' in.req '''']);
        fprintf('\n');
    end
    out{1}.display;

    if strcmp(in.what, 'all')

        if numel(out)==1
            fprintf('\n--- No other result have been found.\n');
        else
        
            fprintf('\n--- Other (shadowed) results:\n');
            for i = 2:numel(out)
                out{2}.Fullpath
            end
        end
    end
        
end

%! ------------------------------------------------------------------------
%! Contributors: Raphaël Candelier
%! Version: 1.4
%
%! Revisions
%   1.4     (2016/05/07): Move most of the content to the ML.Tell objects.
%   1.3     (2016/04/02): Allow for the 'all' option.
%   1.2     (2016/03/14): Complete rewriting. Among several other changes,
%               this version differentiates category and type.
%   1.1     (2015/04/04): Added the pattern-based inclusion/exclusion
%               mechanism.
%   1.0     (2010/01/01): Initial version.
%
%! ------------------------------------------------------------------------