clc

% === Parameters ==========================================================

% -------------------------------------------------------------------------

tmpname = [tempdir ML.uniqid '.html'];

% =========================================================================

conf = ML.config;

Page = ML.Doc.Page();

m = '<h1>Title</h1>';
m = [m '<p>This is a paragraph.<br>'];
m = [m 'This is a paragraph. </p>'];

m = [m '<h1>Plugins</h1>'];
m = [m '<ul>'];

D = ML.dir([conf.path 'Plugins']);
for i = 1:numel(D)
    m = [m '<li>'];
    m = [m '<a href="">' D(i).name '</a>'];
    m = [m '</li>'];
end

m = [m '</ul>'];
m = [m '[ <a href="#">Plugins manager</a> ]'];

Page.main = m;

Page.export('filename', tmpname);
web(tmpname);