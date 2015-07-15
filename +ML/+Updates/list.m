function out = list(varargin)
%ML.Updates.list List updates
%   out = ML.Updates.list()
%
%   See also ML.update

% NB: remember to mlock this file when done.
% NB: remember to do ML.Updates.list('clear', true) after each plugin install.

% --- Inputs

in = ML.Input;
in.what{''} = @(x) ischar(x) || iscellstr(x);
in.check(true) = @islogical;
in.clear(false) = @islogical;
in = +in;

% ---- Persistent variables

% mlock ML.Updates.list
persistent list;

if ~isstruct(list) || in.clear
    
    list = struct('MLab', {{}});
    plist = ML.Plugins.list;
    for i = 1:numel(plist)
        list.(plist{i}) = {};
    end
    
end

% --- Get configutation
config = ML.config;

% --- Define 'what' cell
if isempty(in.what)
    
    if ~exist('plist', 'var')
        plist = ML.Plugins.list; 
    end
    what = [{'MLab'} plist];
    
elseif ischar(in.what)
    
    what = {in.what};
    
else
    
    what = in.what;
    
end
    
% --- Check list
 
for i = 1:numel(what)
    
    if isempty(list.(what{i})) || in.check

        switch what{i}
            case 'MLab'
                gname = java.io.File([config.path '.git']);
            otherwise
                gname = java.io.File([config.path 'Plugins' filesep what{i} filesep '.git']);
        end
        
        Git = org.eclipse.jgit.api.Git.open(gname);
        res = Git.diff.call
        
    end
    
end
    
    
%     || in.check
%     
%     
%     
%     
% end

% --- Output
% if nargout
%     out = what;
% end