classdef Tell < dynamicprops
%       - 'category': a string that can be either 'built-in', 'matlab',
%           'java', 'user' or 'toolbox'.
%       - 'type': a string that can be either 'script', 'function',
%           'package', 'class' or 'method'.
%       - 'extension': Any of the official Mathworks extensions (fig, m,
%           mlx, mat, mdl, slx, mdlp, slxp, mexa64, mexmaci64, mexw32,
%           mexw64, mlapp, mlappinstall, mlpkginstall, mltbx, mn, mu, p).
%           This field is empty in the case of a built-in function or a
%           java method.
%       - 'toolbox': The containing toolbox, if any (default: '').
%       - 'package': The closest parent package, if any (default: '').
%       - 'class': The parent class, if any (default: '').
%       - 'location': The entity location. The fields 'package', 'class'
%           and 'location' are structures themselves, which each contain
%           fields 'path', 'name' and 'fullpath'.
%
% The type is a string that can be either 'File', 'Package',
% 'Class', 'Methods', 'MLab', 'Plugin' or 'Tutotial'.
% The category is a string that can be either 'Built-in', 'Matlab',
% 'Toolbox', 'MLab', 'Plugin' or 'User'.

    properties (Access = public)
       
        Type       
        Name
        Path        
        Category        
        Syntax
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Tell(varargin)
            
            % --- Inputs --------------------------------------------------

            in = ML.Input;
            in.req = @ischar;
            in = +in;
            
            % --- Definitions ---------------------------------------------
            
            % Toolboxes' path
            tpath = [matlabroot filesep 'toolbox' filesep];

            % MLab pathes
            conf = ML.config;
            ppath = [conf.path 'Plugins' filesep];
            
            % --- Define Type, Name, Path ---------------------------------
            
            % --- Built-in functions
            tmp = regexp(in.req, '^built-in \((.*)\)', 'tokens');
            if ~isempty(tmp)
                this.Type = 'File';
                [this.Path, this.Name] = fileparts(tmp{1}{1});
                this.Category = 'Built-in';
            end

            % --- Files
            if exist(in.req, 'file')
                
                % --- Methods
                if strfind(in.req, [filesep '@'])
                    this.Type = 'Method';
                    
                % --- Scripts & functions
                else
                    this.Type = 'File';
                    addprop(this, 'Extension');
                    [this.Path, this.Name, this.Extension] = fileparts(in.req);
                end
            end
            
            % --- Folders
            
        
            % --- Category ------------------------------------------------
            
            if strfind(in.req, [tpath 'matlab' filesep])
                
                % --- Matlab
                this.Category = 'Matlab';
            
            elseif strfind(in.req, tpath)
                
                % --- Toolbox
                this.Category = 'Toolbox';
                
            elseif strfind(in.req, ppath)
                
                % --- Plugin
                this.Category = 'Plugin';
                
            elseif strfind(in.req, conf.path)
                
                % --- MLab
                this.Category = 'MLab';
                
            else
                
                % --- User
                this.Category = 'User';
                
            end

            % --- Pseudomethods -------------------------------------------
            
            % WHY DOESN'T THIS WORK ?!?
            this.addpseudomethod('test');
            
            % --- Dynamic properties / pseudomethods based on Type --------
            
            switch this.Type
                
                case 'File'
            
                    % --- Get file extension
                    if ~isprop(this, 'Extension')
                        addprop(this, 'Extension');
                        tmp = dir([this.Path filesep this.Name '.*']);
                        if numel(tmp)==1
                            res = regexp(tmp.name, '(\.[a-zA-Z0_9]+)$', 'tokens');
                            if ~isempty(res)
                                this.Extension = res{1}{1};
                            end
                        end
                        
                    end
                    
                    % --- Get fullpath
                    addprop(this, 'Fullpath');
                    this.Fullpath = [this.Path filesep this.Name this.Extension];
                    
                    % --- Is script ?
                    this.addpseudomethod('isscript');

            end
            
            % --- Dynamic properties / pseudomethods based on Category ----
            switch this.Category
                
                case 'Toolbox'
                    this.addpseudomethod('Toolbox');
            
                case 'Plugin'
                    this.addpseudomethod('Plugin');
                    
            end
            
            % --- Determine syntax
            
        end
        
    end
end