function config(varargin)
%ML.config MLab configuration tool
%   ML.CONFIG() starts the MLab configuration command line interface.
%
%   See also ML.start.
%
%   Reference page in Help browser: <a href="matlab:doc ML.config">doc ML.config</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% === Input variables =====================================================

in = inputParser;
in.addOptional('unfold', '', @ischar);
in.addOptional('action', '', @ischar);
in.addOptional('custom', '', @ischar);

in.parse(varargin{:});
in = in.Results;

% =========================================================================

% --- Get config
[config, fname] = ML.Config.get;

% --- Handy handles
sin = @(s) fprintf('%s: [Enter to skip]\n', s);
sl1 = @(s) fprintf('\n <strong>%s</strong>\n\n', s);
sl2f = @(s, u) fprintf('  <a href="matlab: ML.config(''%s'');">%s %s</a>\n', u, char(8862), s);
sl2u = @(s) fprintf('  <a href="matlab: ML.config;">%s %s</a>\n', char(8863), s);
sl3 = @(k, v, u, a) fprintf('    <a href="matlab: ML.config(''%s'', ''%s'')">%s</a>\t%s\n', u, a, k, v);
isu = @(s) strcmp(in.unfold, s);
nl = @() fprintf('\n');

% --- Startup commands
suc = ['if exist([prefdir filesep ''MLab.mat''], ''file'')' char(10) ...
       char(9) 'tmp = load([prefdir filesep ''MLab.mat'']);' char(10) ...
       char(9) 'addpath(genpath(tmp.config.path), ''-end'');' char(10)...
       char(9) 'if tmp.config.startup.autostart' char(10)...
       char([9 9]) 'ML.start' char(10)...
       char(9) 'end' char(10)...
       'end' char([10 10])];

% --- Action (optional)
if ~isempty(in.action)
    
    switch in.action
        
        % --- SHORTCUTS
        case {'SC_Start', 'SC_Config', 'SC_Update'}
            tag = in.action(4:end);
            S = com.mathworks.mlwidgets.shortcuts.ShortcutUtils;
            if ismember(tag, arrayfun(@char, S.getShortcutsByCategory('MLab').toArray, ...
                'UniformOutput', false))
                S.removeShortcut('MLab', tag);
            else
                switch tag
                    case 'Start', scc = 'ML.start';
                    case 'Config', scc = 'ML.config';
                    case 'Update', scc = 'ML.Updates.update(''force'', true)';
                end
                
                S.addShortcutToBottom(tag, ...
                    scc, [config.path 'Images' filesep 'Shortcuts/' tag '.png'], ...
                    'MLab', 'true');
            end
                    
        % ---STARTUP
        case 'create_startup'
            sname = fullfile(matlabroot, 'toolbox', 'local', 'startup.m');
            [fid, msg] = fopen(sname, 'w');
            if fid<0
                warning('ML:config:fopenError', msg);
                create_startup_failed = true;
            else
                fprintf(fid, '%% === MLab startup ========================================================\n');
                fprintf(fid, '%% This code has been generated automatically, please do not modify it.\n\n');
                fprintf(fid, '%s', suc);
                fprintf(fid, '%% =========================================================================\n');
                fclose(fid);
                rehash toolbox
            end
            
        case 'SU_addpath'
            config.startup.addpath = ~config.startup.addpath;
        
        case 'SU_updates'
            config.startup.check_updates = ~config.startup.check_updates;
            
        case 'SU_autostart'
            config.startup.autostart = ~config.startup.autostart;
            
        % --- USER INFO
            
        case 'name'
            sin('Please enter your name');
            tmp = input('?> ', 's');
            if isempty(tmp), ML.config(in.unfold);
            else config.user.name = tmp; end
            
        case 'email'
            sin('Please enter your email adress');
            tmp = input('?> ', 's');
            if isempty(tmp), ML.config(in.unfold);
            else config.user.email = tmp; end
        
        % --- UPDATES
        
        case 'mirror_url'
            sin('Please enter the new mirror url');
            tmp = input('?> ', 's');
            if isempty(tmp), ML.config(in.unfold);
            else config.updates.mirror_url = tmp; end
            
        case 'check_delete'
            config.updates.check_delete = ~config.updates.check_delete;
            
        otherwise
            try
                eval(['ML.Plugins.' in.action '.shortcut(''' in.custom ''')']);
            catch err
                display(err.message);
            end
                
    end
    
    % Save configuration
    save(fname, 'config');
    
end

% --- Display

clc

% --- MLab ----------------------------------------------------------------
sl1('MLab Configuration');

% --- Shortcuts
if isu('shortcuts')
    sl2u('Shortcuts');
    
    S = com.mathworks.mlwidgets.shortcuts.ShortcutUtils;

    % Add new category (of not existing)
    if ~ismember('MLab', cell(S.getShortcutCategories))
        S.addNewCategory('MLab');
    end
    
    % List installed shortcuts
    sl = arrayfun(@char, S.getShortcutsByCategory('MLab').toArray, ...
        'UniformOutput', false);
    
    sl3(bool2string(ismember('Start',sl)), 'Start' , 'shortcuts', 'SC_Start');
    sl3(bool2string(ismember('Config',sl)), 'Configuration' , 'shortcuts', 'SC_Config');
    sl3(bool2string(ismember('Update',sl)), 'Update' , 'shortcuts', 'SC_Update');
    
    % --- Plugins
    pl = ML.Plugins.list;
    for i = 1:numel(pl)
        try 
            eval(['ML.Plugins.' pl{i} '.shortcut(''disp'')']);
        catch
        end
    end
    
    nl();
else
    sl2f('Shortcuts', 'shortcuts');
end

% --- Startup
if isu('startup')
    sl2u('Startup');
    
    % --- Check that startup.m exists and calls ML.startup
    
    sname = which('startup');
    fid = fopen(sname, 'r');
    
    if fid<0

        tmp = get(0,'CommandWindowSize');
        line = repmat('_', [1 tmp(1)]);
        
        fprintf('    No startup file is present in your search path.\n');
        
        if exist('create_startup_failed', 'var') && create_startup_failed
            fprintf('    To enable MLab startup options, you have to create the file:\n\n');
            fprintf('      %s\n\n', fullfile(matlabroot, 'toolbox', 'local', 'startup.m'));
            fprintf('    and write the following commands in it:\n\n');
            fprintf('%s\n\n%s%s\n\n', line, suc, line);
        else
            fprintf('    Click <a href="matlab: ML.config(''startup'', ''create_startup'')">here</a> to try to do it automatically.\n');
        end
    else
        
        C = textscan(fid, '%s',  'delimiter', {'\n','\r'});
        fclose(fid);
           
        if ~any(ismember(C{1}, 'ML.start'));
           
            tmp = get(0,'CommandWindowSize');
            line = repmat('_', [1 tmp(1)]);
            
            fprintf('    No call to the ML.startup script is present in your startup file.\n');
            fprintf('    Please modify your startup file:\n\n');
            fprintf('      <a href="matlab:edit ''%s''">%s</a>\n\n', sname, sname);
            fprintf('    by adding the following lines:\n\n');
            fprintf('%s\n\n%s%s\n\n', line, suc, line);
        
        else
            sl3(bool2string(config.startup.check_updates), 'Check for updates at startup' , 'startup', 'SU_updates');
            sl3(bool2string(config.startup.autostart), 'Start MLab at startup' , 'startup', 'SU_autostart');
        end
    end
 
    nl();
else
    sl2f('Startup', 'startup');
end


% --- User
if isu('user')
    sl2u('User info');
    sl3('Name', config.user.name, 'user', 'name');
    sl3('Email', config.user.email, 'user', 'email');
    nl();
else
    sl2f('User info', 'user');
end

% --- Updates
if isu('updates')
    sl2u('Updates');
    sl3('Mirror URL', config.updates.mirror_url, 'updates', 'mirror_url');
    sl3(bool2string(config.updates.check_delete), 'Search for files to delete' , 'updates', 'check_delete');
    nl();
else
    sl2f('Updates', 'updates');
end

% -------------------------------------------------------------------------
function s = bool2string(b)

if b, s = 'Yes';
else s = 'No'; end