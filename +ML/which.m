function target = which(varargin)
%ML.which Locate functions, packages, classes and methods
%   ML.which(NAME) display in
%
% Shadowing: 
%   class > package
%   function > package
%

% TO DO:
% - Check precedence/shadowing
% - Add option for specifying type

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.loc{''} = @(x) ischar(x) || ML.isfunction_handle(x);
in = +in;

% --- Checks

% Convert in.loc to string
if ML.isfunction_handle(in.loc)
    in.loc = func2str(in.loc);
end

conf = ML.config;
ppath = [conf.path 'Plugins' filesep];

% --- Define output
target = struct('type', {}, 'plugin', {}, 'package', {}, 'path', {}, 'name', {});

% Home
if ~isempty(in.loc)
    
    % Add 'ML.' at the beginning of in.loc
    loc = in.loc;
    if numel(loc)<4 || ~strcmp(loc(1:3), 'ML.')
        loc = ['ML.' loc];
    end
    
    w = which(loc);
    if ~isempty(w)
        
        % ... File or Class ...
        
        % --- Type
        if ~isempty(strfind(w, [filesep '@']))
            target(1).type = 'class';
        else
            target(1).type = 'mfile';
        end
        
        % --- Plugin
        if strcmp(w(1:numel(ppath)), ppath)
            fp = strfind(w(numel(ppath)+1:end),filesep);
            target.plugin = w(numel(ppath)+(1:fp(1)-1));
        end
        
        % --- Package
        if isempty(target.plugin)
            p = [conf.path '+ML' filesep];
        else
            p = [conf.path 'Plugins' filesep target.plugin filesep '+ML' filesep];
        end
        [tmp, target.name] = fileparts(w(numel(p)+1:end));
        
        if (~isempty(tmp) && strcmp(tmp(1), '@')) || ~isempty(strfind(tmp, [filesep '@']))
            tmp = fileparts(tmp);
        end
        
        if isempty(tmp)
            target.package = 'ML';
        else
            tmp = strrep(tmp, filesep, '.');
            target.package = ['ML.' strrep(tmp, '+', '')];
        end
        
        % --- Path
        target.path = w;
        
    else
        % ... Package or method ...

        p = meta.package.fromName(loc);
        if ~isempty(p)
            % ... Package ...
            
            % --- Type
            target(1).type = 'package';
            
            % --- Package
            target.package = p.ContainingPackage.Name;
            
            % --- Name
            I = strfind(p.Name, '.');
            target.name = p.Name(I(end)+1:end);
            
            % --- Path
            epath = ['+' strrep(p.Name, '.', [filesep '+'])];
            tmp = what([p.Name(1:I(1)-1)]);
            for i = 1:numel(tmp)
                w = [tmp(i).path(1:end-I(1)) epath];
                if exist(w, 'dir'), break; end
            end
            target.path = w;
            
            % --- Plugin
            if strcmp(w(1:numel(ppath)), ppath)
                fp = strfind(w(numel(ppath)+1:end),filesep);
                target.plugin = w(numel(ppath)+(1:fp(1)-1));
            end
            
        else
            
            % ... Method ...
            
            % --- Name
            I = strfind(loc, '.');
            
            if strcmp(loc(1:I(end)-1), 'ML'), return; end
            
            Class = ML.which(loc(1:I(end)-1));
            
            tgpath = [fileparts(Class.path) filesep loc(I(end)+1:end) '.m'];
            
            if exist(tgpath, 'file')
                
                % --- Type
                target(1).type = 'method';
                
                % --- Name
                target.name = loc(I(end)+1:end);
                
                % --- Path
                target.path = tgpath;
                
                % --- Plugin
                target.plugin = Class.plugin;
                
                % --- Package
                target.package = Class.package;
                
                % --- Classname
                target.class = Class.name;
                
            end
            
        end
        
    end
    
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.0
%
%! Revisions
%   1.1     (2015/04/04): Added the pattern-based inclusion/exclusion 
%               mechanism.
%   1.0     (2010/01/01): Initial version.
%
%! To_do
%   Write ML.doc.
%! ------------------------------------------------------------------------
%! Doc
%   <title>Custom title</title>