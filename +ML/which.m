function OUT = which(varargin)
%ML.which Locate functions, packages, classes, methods and more
%   ML.which(NAME) displays information on the script, function, package,
%   class, method or MLab item (MLab, plugin or tutorial) designated by the
%   entity NAME.
%
%   ML.which(..., 'all') displays information on all items designated by
%   the entity NAME. The first entry is the one that is accessible in the
%   path, the others are shadowed. The syntax '-all' is also accepted for
%   compatibility with Matlab's <a href="matlab:doc which">which</a> function.
%
%   ML.which(..., 'notfound', NFP) uses a "not found procedure". NFP is a
%   string which can be:
%       - 'none': Nothing is done
%       - 'info': A message is displayed in the command window
%       - 'warning': (default) A warning is thrown
%       - 'error': An error is thrown
%
%   out = ML.which(...) returns a ML.Tell object, or a cell of ML.Tell
%   objects if the 'all' option is invoked.
%
%   See also which, lookfor, exist

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.req = @(x) ischar(x) || isa(x, 'function_handle');
in.what{'one'} = @(x) ismember(x, {'one', 'all', '-all'});
in.notfound{'warning'} = @(x) ismember(x, {'none', 'info', 'warning', 'error'});
in = +in;

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
% --- Definitions ---------------------------------------------------------

% --- Output
isnotfound = false;

% --- Category and type ---------------------------------------------------

if strcmp(in.what, 'all')
    
    tmp = which(in.req, '-all');
    for i = 2:numel(tmp)
        tmp{i}
        ML.Tell(tmp{i})
    end
    
    % out = cellfun(@ML.Tell, which(in.req, '-all'), 'UniformOutput', false);
    
else
    
    out = ML.Tell(which(in.req));
    
end

% % % for i = 1:numel(path)
% % %
% % %     path{i}
% % %
% % %     if ~isempty(path{i})      % ::: File or class ::::::::::::::::::::::::::::::::
% % %
% % %         % --- Category
% % %
% % %         if regexp(path{i}, '^built-in \(.*\)', 'once')
% % %
% % %             % Built-in
% % %             out(i).category = 'built-in';
% % %
% % %             % Redefine path
% % %             tmp = regexp(path{i}, '^built-in \((.*)\)', 'tokens');
% % %             path{i} = tmp{1}{1};
% % %
% % %         elseif strfind(path{i}, [tpath 'matlab' filesep])
% % %
% % %             % Matlab
% % %             out(i).category = 'matlab';
% % %
% % %         elseif strfind(path{i}, tpath)
% % %
% % %             % Toolbox
% % %             x = path(numel(tpath)+1:end);
% % %             out(i).category = 'toolbox';
% % %             out(i).toolbox = x(1:strfind(x, filesep)-1);
% % %
% % %         else
% % %
% % %             % User
% % %             out(i).category = 'user';
% % %
% % %         end
% % %
% % %         % --- Type
% % %
% % %         if strfind(path{i}, [filesep '@'])
% % %
% % %             % --- Class
% % %             out(i).type = 'class';
% % %             path{i} = fileparts(path{i});
% % %
% % %         elseif ismember(path{i}(end-1:end), {'.m', '.p'})
% % %
% % %             % --- Script or function ?
% % %             try
% % %                 nargin(path{i});
% % %                 sof = 'function';
% % %             catch EX
% % %                 if strcmp(EX.identifier, 'MATLAB:nargin:isScript')
% % %                     sof = 'script';
% % %                 else
% % %                     rethrow(EX);
% % %                 end
% % %             end
% % %
% % %             % --- Type of file (mfile, pfile, builtin)
% % %             if strcmp(path{i}(end-1:end), '.m')
% % %                 out(i).type = [sof ':mfile'];
% % %             else
% % %                 out(i).type = [sof ':pfile'];
% % %             end
% % %
% % %         else
% % %             out(i).type = 'function';
% % %         end
% % %
% % %     else                    % ::: Package or method :::::::::::::::::::::::::::
% % %
% % %         p = meta.package.fromName(in.req);
% % %
% % %         if ~isempty(p)      % ::: Package :::
% % %
% % %             % --- Type
% % %             out(i).type = 'package';
% % %
% % %             % --- Path
% % %             I = strfind(p.Name, '.');
% % %             if isempty(I)
% % %                 tmp = what(p.Name);
% % %                 for j = 1:numel(tmp)
% % %                     path{i} = tmp(j).path;
% % %                     if exist(path{i}, 'dir'), break; end
% % %                 end
% % %             else
% % %                 epath = ['+' strrep(p.Name, '.', [filesep '+'])];
% % %                 tmp = what(p.Name(1:I(1)-1));
% % %                 for j = 1:numel(tmp)
% % %                     path{i} = [tmp(j).path(1:end-I(1)) epath];
% % %                     if exist(path{i}, 'dir'), break; end
% % %                 end
% % %             end
% % %
% % %             % --- Category
% % %             if strfind(path{i}, [tpath 'matlab' filesep])
% % %
% % %                 % Matlab
% % %                 out(i).category = 'matlab';
% % %
% % %             elseif strfind(path{i}, tpath)
% % %
% % %                 % Toolbox
% % %                 x = path{i}(numel([matlabroot filesep 'toolbox' filesep])+1:end);
% % %                 out(i).category = ['toolbox:' x(1:strfind(x, filesep)-1)];
% % %
% % %             else
% % %
% % %                 % User
% % %                 out(i).category = 'user';
% % %
% % %             end
% % %
% % %         else                % ::: Method (or junk) :::
% % %
% % %             % Check for junk
% % %             k = find(in.req=='.', 1, 'last');
% % %             if isempty(k) || isempty(which(in.req(1:k-1)))
% % %                 isnotfound = true;
% % %             else
% % %
% % %                 % Class & category
% % %                 cls = ML.which(in.req(1:k-1));
% % %                 out(i).class = cls.location;
% % %                 out(i).category = cls.category;
% % %
% % %                 % Path
% % %                 if exist([cls.location.fullpath filesep in.req(k+1:end) '.m'], 'file')
% % %                     path{i} = [cls.location.fullpath filesep in.req(k+1:end) '.m'];
% % %                 elseif exist([cls.location.fullpath filesep in.req(k+1:end) '.p'], 'file')
% % %                     path{i} = [cls.location.fullpath filesep in.req(k+1:end) '.p'];
% % %                 else
% % %                     isnotfound = true;
% % %                 end
% % %
% % %                 if ~isnotfound
% % %                     if strcmp(path{i}(end-1:end), '.m')
% % %                         out(i).type = 'method:mfile';
% % %                     elseif strcmp(path{i}(end-1:end), '.p')
% % %                         out(i).type = 'method:pfile';
% % %                     end
% % %                 end
% % %             end
% % %         end
% % %
% % %     end
% % %
% % %     % --- Nothing found ---
% % %
% % %     if isnotfound
% % %
% % %         if nargout
% % %             OUT = struct();
% % %         else
% % %             switch in.notfound
% % %                 case 'info'
% % %                     fprintf('Could not find anything for ''%s''.\n', in.req);
% % %                 case 'warning'
% % %                     warning('Which::NotFound', ['Could not find anything for ''' in.req '''.']);
% % %                 case 'error'
% % %                     error('Which::NotFound', ['Could not find anything for ''' in.req '''.']);
% % %             end
% % %         end
% % %
% % %         return
% % %     end
% % %
% % %     % --- Location ------------------------------------------------------------
% % %
% % %     out(i).location = struct('fullpath', path{i});
% % %     [out(i).location.path, out(i).location.name] = fileparts(out(i).location.fullpath);
% % %     if ismember(out(i).type, {'package', 'class'})
% % %         out(i).location.name(1) = [];
% % %     end
% % %
% % %     % --- Package -------------------------------------------------------------
% % %
% % %     I = strfind(out(i).location.path, '+');
% % %     if ~isempty(I)
% % %         out(i).package = struct('path', '', 'name', '', 'fullpath', '', 'syntax', '');
% % %         reg = regexp(out(i).location.path, '(.*)(\+[^\+\\/]*)([\\/]@.*)?$', 'tokens');
% % %         out(i).package.path = reg{1}{1};
% % %         out(i).package.name = reg{1}{2}(2:end);
% % %         out(i).package.fullpath = [reg{1}{1} reg{1}{2}];
% % %     end
% % %
% % %     out(i)
% % %
% % % end

% --- Output & display ----------------------------------------------------

if nargout
    
    OUT = out;
    
else
    
    if strcmp(in.what, 'all')
        
        out{1}.display;
        
    else
        
        out.display
        
    end
    
    % --- Display
    %     out = out(1);
    
    %     % Preparation
    %     fprintf(['Which <strong>' in.req '</strong>\n']);
    %
    %     fprintf('<strong>Location</strong>: %s\n', out.location.fullpath);
    %     fprintf('<strong>Category</strong>: %s\n', out.category);
    %     fprintf('<strong>Type</strong>:     %s\n', out.type);
    %
    %     if ~isempty(out.package) || isstruct(out.class)
    %         fprintf('\n');
    %
    %         if ~isempty(out.package)
    %             fprintf('Part of the <strong>package</strong>: %s (%s)\n', ...
    %                 out.package.name, out.package.fullpath);
    %         end
    %
    %         if isstruct(out.class)
    %             fprintf('Method of <strong>class</strong>: %s (%s)\n', ...
    %                 out.class.name, out.class.fullpath);
    %         end
    %     end
    %
    %     fprintf('\n');
    
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