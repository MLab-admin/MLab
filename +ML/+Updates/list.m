function out = list(varargin)
%ML.Updates.list List updates
%   out = ML.Updates.list()
%
%   See also ML.update

% NB: remember to mlock this file when done.
% NB: remember to do ML.Updates.list('clear', true) after each plugin install.

clc

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
        
        list.(what{i}) = {};
        
        switch what{i}
            case 'MLab'
                gname = java.io.File([config.path '.git']);
            otherwise
                gname = java.io.File([config.path 'Plugins' filesep what{i} filesep '.git']);
        end
        
        % --- Git diff
        Git = org.eclipse.jgit.api.Git.open(gname);
        cmd = Git.diff;
        repo = Git.getRepository;
        reader = repo.newObjectReader;
        cmd.setOldTree(org.eclipse.jgit.treewalk.CanonicalTreeParser([], reader, repo.resolve('master^{tree}')));
        cmd.setNewTree(org.eclipse.jgit.treewalk.CanonicalTreeParser([], reader, repo.resolve('origin/master^{tree}')));
        res = cmd.call.toArray;
                
        % --- Process result
        for j = 1:numel(res)
            tmp = char(res(j));
            list.(what{i}){end+1} = tmp(11:end-1);
        end
        
    end
    
end

list


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