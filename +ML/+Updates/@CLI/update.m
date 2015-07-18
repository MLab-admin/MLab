function out = update(this, varargin)
% ML.Updates.CLI/update CLI update method
%   ML.Updates.CLI/update(W) updates the element W. W can be 'MLab' or a
%   plugin identifier.
%
%   See also ML.Updates.CLI

% --- Inputs
in = ML.Input;
in.what = @ischar;
in = +in;

% ---Output 
out = true;

% --- Cellification
if strcmp(in.what, 'all')
    F = fieldnames(this.list);
    in.what = {};
    for i = 1:numel(F)
        if ~isempty(this.list.(F{i}))
            in.what{end+1} = F{i};
        end
    end
else
    in.what = {in.what};
end

if isempty(in.what), return; end

% --- Updates

% MLab path
mpath = getpref('MLab', 'path');

for i = 1:numel(in.what)

    switch in.what{i}
        case 'MLab'
            upath = mpath;
            
        otherwise
            upath = [mpath 'Plugins' filesep in.what{i} filesep];
    end
    
    Git = org.eclipse.jgit.api.Git.open(java.io.File([upath '.git']));
    m = Git.pull.call;
    
    m
    
end

pause