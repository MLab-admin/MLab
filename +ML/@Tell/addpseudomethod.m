function addpseudomethod(this, prop)

% --- Definitions ---------------------------------------------------------

% Toolboxes' path
tpath = [matlabroot filesep 'toolbox' filesep];

% MLab pathes
conf = ML.config;
ppath = [conf.path 'Plugins' filesep];

% --- Append pseudomethod -------------------------------------------------

addprop(this, prop);
p = findprop(this, prop);
eval(['p.GetMethod = @(this) ' prop '(this);'])

% === Nested functions ====================================================

    % ---------------------------------------------------------------------
    function out = isinPackage(this)
        
        out = ~isempty(strfind(this.Path, [filesep '+']));
        
    end

    % ---------------------------------------------------------------------
    function out = Toolbox(this)
        
        x = this.Path(numel(tpath)+1:end);
        out = x(1:strfind(x, filesep)-1);
        
    end

    % ---------------------------------------------------------------------
    function out = getPlugin(this)
        
        out = 'plugin_todo !';
%         x = path(numel(ppath)+1:end);
%         out.category = ['plugin:' x(1:strfind(x, filesep)-1)];
        
    end

    % ---------------------------------------------------------------------
    function out = isscript(this)

        % --- Checks
        if ismember(this.Category, {'Built-in', 'MLab'})
            out = false;
            return
        end
        
        % --- Nargin test
        try
            nargin(this.Fullpath);
            out = false;
        catch Ex
            if strcmp(Ex.identifier, 'MATLAB:nargin:isScript')
                out = true;
            else
                rethrow(Ex);
            end
        end
        
    end

end
