function OUT = which(varargin)
%ML.which Locate functions, packages, classes and methods
%   ML.which(NAME) displays information on the script, function, package,
%   class or method in NAME.
%
%   out = ML.which(...) returns a structure containing the following
%       fields:
%       - 'category': a string that can be either 'built-in', 'matlab',
%           'toolbox:...', 'user', 'MLab' or 'plugin:...'. The '...'
%           contain the toolbox or plugin name.
%       - 'type': a string that can be either 'script:mfile',
%           'script:pfile', 'function:builtin', 'function:mfile',
%           'function:pfile', 'package', 'class', 'method:mfile' or
%           'method:pfile'.
%       - 'package': The closest parent package, if any (default: '').
%       - 'class': The parent class, if any(default: '').
%       - 'location': The entity location. The fields 'package', 'class'
%           and 'location' are structures themselves, which each contain
%           fields 'path', 'name' and 'fullpath'.
%
%   Note: This function does not permit to find shadowed entities. Packages
%   are shadowed by functions and classes.
%
%   See also which, ML.where

% TO DO:
% - Add option for specifying type
% - Check shadowing and propose alternatives on display

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.req{''} = @(x) ischar(x) || ML.isfunction_handle(x);
in.notfound('warning') = @(x) ismember(x, {'none', 'info', 'warning', 'error'});
in = +in;

% --- Checks --------------------------------------------------------------

% Convert in.req to string
if ML.isfunction_handle(in.req)
    in.req = func2str(in.req);
end

if isempty(in.req)
    warning('ML:which', 'Empty input.');
    return
end

% --- Definitions ---------------------------------------------------------

% --- Configuration
tpath = [matlabroot filesep 'toolbox' filesep];
conf = ML.config;
ppath = [conf.path 'Plugins' filesep];

% --- Output
out = struct('category', '', 'type', '', 'package', '', 'class', '', 'location', '');
isnotfound = false;

% --- Category and type ---------------------------------------------------

path = which(in.req);

if ~isempty(path)      % ::: File or class ::::::::::::::::::::::::::::::::
    
    % --- Category
    
    if regexp(path, '^built-in \(.*\)', 'once')
        
        % Built-in
        out.category = 'built-in';
        
        % Redefine path
        tmp = regexp(path, '^built-in \((.*)\)', 'tokens');
        path = tmp{1}{1};
        
        
    elseif strfind(path, [tpath 'matlab' filesep])
        
        % Matlab
        out.category = 'matlab';
        
    elseif strfind(path, tpath)
        
        % Toolbox
        x = path(numel(tpath)+1:end);
        out.category = ['toolbox:' x(1:strfind(x, filesep)-1)];
        
    elseif strfind(path, ppath)
        
        % Plugin
        x = path(numel(ppath)+1:end);
        out.category = ['plugin:' x(1:strfind(x, filesep)-1)];
        
    elseif strfind(path, conf.path)
        
        % MLab
        out.category = 'MLab';
        
    else
        
        % User
        out.category = 'user';
        
    end
    
    % --- Type
    
    if strfind(path, [filesep '@'])
        
        % --- Class
        out.type = 'class';
        path = fileparts(path);
        
    elseif ismember(path(end-1:end), {'.m', '.p'})
        
        % --- Script or function ?
        try
            nargin(path);
            sof = 'function';
        catch EX
            if strcmp(EX.identifier, 'MATLAB:nargin:isScript')
                sof = 'script';
            else
                rethrow(EX);
            end
        end
        
        % --- Type of file (mfile, pfile, builtin)
        if strcmp(path(end-1:end), '.m')
            out.type = [sof ':mfile'];
        else
            out.type = [sof ':pfile'];
        end
        
    else
        out.type = 'function:builtin';
    end
    
else                    % ::: Package or method :::::::::::::::::::::::::::
    
    p = meta.package.fromName(in.req);
    
    if ~isempty(p)      % ::: Package :::
        
        % --- Type
        out.type = 'package';
        
        % --- Path
        I = strfind(p.Name, '.');
        if isempty(I)
            tmp = what(p.Name);
            for i = 1:numel(tmp)
                path = tmp(i).path;
                if exist(path, 'dir'), break; end
            end
        else
            epath = ['+' strrep(p.Name, '.', [filesep '+'])];
            tmp = what(p.Name(1:I(1)-1));
            for i = 1:numel(tmp)
                path = [tmp(i).path(1:end-I(1)) epath];
                if exist(path, 'dir'), break; end
            end
        end
        
        % --- Category
        if strfind(path, [tpath 'matlab' filesep])
            
            % Matlab
            out.category = 'matlab';
            
        elseif strfind(path, tpath)
            
            % Toolbox
            x = path(numel([matlabroot filesep 'toolbox' filesep])+1:end);
            out.category = ['toolbox:' x(1:strfind(x, filesep)-1)];
            
        elseif strfind(path, ppath)
            
            % Plugin
            x = path(numel(ppath)+1:end);
            out.category = ['plugin:' x(1:strfind(x, filesep)-1)];
            
        elseif strfind(path, conf.path)
            
            % MLab
            out.category = 'MLab';
            
        else
            
            % User
            out.category = 'user';
            
        end
        
        
    else                % ::: Method (or junk) :::
        
        % Check for junk
        k = find(in.req=='.', 1, 'last');
        if isempty(k) || isempty(which(in.req(1:k-1)))
            isnotfound = true;
        else
            
            % Class & category
            class = ML.which(in.req(1:k-1));
            out.class = class.location;
            out.category = class.category;
            
            % Path
            if exist([class.location.fullpath filesep in.req(k+1:end) '.m'], 'file')
                path = [class.location.fullpath filesep in.req(k+1:end) '.m'];
            elseif exist([class.location.fullpath filesep in.req(k+1:end) '.p'], 'file')
                path = [class.location.fullpath filesep in.req(k+1:end) '.p'];
            else
                isnotfound = true;
            end
            
            if ~isnotfound
                if strcmp(path(end-1:end), '.m')
                    out.type = 'method:mfile';
                elseif strcmp(path(end-1:end), '.p')
                    out.type = 'method:pfile';
                end
            end
        end
    end
    
end

% --- Nothing found ---

if isnotfound
    
    if nargout
        OUT = struct();
    else
        switch in.notfound
            case 'info'
                fprintf('Could not find anything for ''%s''.\n', in.req);
            case 'warning'
                warning('MLab:which', ['Could not find anything for ''' in.req '''.']);
            case 'error'
                error('MLab:which', ['Could not find anything for ''' in.req '''.']);
        end
    end
    
    return
end

% --- Location ------------------------------------------------------------

out.location = struct('fullpath', path);
[out.location.path, out.location.name] = fileparts(out.location.fullpath);
if ismember(out.type, {'package', 'class'})
    out.location.name(1) = [];
end

% --- Package -------------------------------------------------------------

I = strfind(out.location.path, '+');
if ~isempty(I)
    out.package = struct('path', '', 'name', '', 'fullpath', '', 'syntax', '');
    reg = regexp(out.location.path, '(.*)(\+[^\+\\/]*)([\\/]@.*)?$', 'tokens');
    out.package.path = reg{1}{1};
    out.package.name = reg{1}{2}(2:end);
    out.package.fullpath = [reg{1}{1} reg{1}{2}];
end

% --- Output & display ----------------------------------------------------

if nargout
    OUT = out;
else
    
    % --- Display
    
    % Preparation
    fprintf('\n');
    ML.CW.line(['Which ~b{' in.req '}']);
    
    ML.CW.print('~b{Location}: %s\n', out.location.fullpath);
    ML.CW.print('~b{Category}: %s\n', out.category);
    ML.CW.print('~b{Type}:     %s\n', out.type);
    
    if ~isempty(out.package) || isstruct(out.class)
        fprintf('\n');
        
        if ~isempty(out.package)
            ML.CW.print('Part of the ~b{package}: %s (%s)\n', ...
                out.package.name, out.package.fullpath);
        end
        
        if isstruct(out.class)
            ML.CW.print('Method of ~b{class}: %s (%s)\n', ...
                out.class.name, out.class.fullpath);
        end
    end
    
    fprintf('\n');
    
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.2
%
%! Revisions
%   1.2     (2016/03/14): Complete rewriting. Among several other changes,
%               this version differentiates category and type.
%   1.1     (2015/04/04): Added the pattern-based inclusion/exclusion
%               mechanism.
%   1.0     (2010/01/01): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>Custom title</title>