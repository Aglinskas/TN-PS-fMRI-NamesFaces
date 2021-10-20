cd '/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/'




%%
mesh_file_dir  = '/Users/aidasaglinskas/Desktop/BC-ASD-FC/Code/MATLABS-Scripts/spm12/canonical/'
fls = [dir([mesh_file_dir '*.gii']) dir([mesh_file_dir '*.mat'])];
fls = {fls.name}';
M = fullfile(mesh_file_dir,fls{1});
H = spm_mesh_render(M)
spm_mesh_inflate(H.patch,50,0)

if ~exist('run_once')
all.faces = H.patch.Faces;
all.VertexNormals = H.patch.VertexNormals;
all.vertices = H.patch.Vertices;
all.FaceVertexCData = H.patch.FaceVertexCData
C   = getappdata(H.patch,'cclabel');
run_once=1;
end
%%
con_idxs = [6 11 10 12 13]
con_names = {'nominal','physical','social','episodic', 'biographical'}
ks = [102 60 97 91 100]
combxSPM = []


load('/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Data/Group_Analysis_subconst/SPM.mat')
SPM.swd = '/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Data/Group_Analysis_subconst/'

for t = 1:length(con_idxs)
xSPM = SPM;
xSPM.Ic = con_idxs(t);
xSPM.Ex=0;
xSPM.Im= [];
xSPM.title=SPM.xCon(xSPM.Ic).name;
xSPM.thresDesc='none';
xSPM.u= .001;
xSPM.k= ks(t);
[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
%spm_sections(xSPM,hReg,temp.sections_fn) %SECTIONS
xSPM.t = xSPM.Z;
xSPM.dim = xSPM.DIM;
xSPM.mat = xSPM.M;
combxSPM = [combxSPM xSPM]
end
%%

con_names = {'nominal','physical','social','episodic'}

col = [
     73 184 190
     70 168 69
     234 224 63
     220 33 43
     0     1     1]/255 * 2.25; % [red purple yellow green cyan] aidas
 
for t = 1:length(combxSPM)
spm_mesh_render('overlay',H,combxSPM(t))
spm_mesh_render('ColourMap',H,col(t,:)) %col(t,:))

for i = 1:2
pos = [90 0
    -90 0]
view(H.axis,pos(i,:));
axis(H.axis,'image');
camlight(H.light);
exp = 1;
if exp == 1
ofn_dir = '/Users/aidasaglinskas/Desktop/SPMS/';
ofn_nm = ['HemRight_' 'task' num2str(t) '_view' num2str(i) '.png'];
ofn = fullfile(ofn_dir,ofn_nm);
saveas(H.figure,ofn,'png')
end
end %SPMS
end
%%
ofn_root = '/Users/aidasaglinskas/Desktop/SPMS/';
fn_temp  = '%s_task%d_view%d.png';
str = {'HemRight' 'HemLeft'}
haxis=[]
for t = 1:length(combxSPM)
f = figure(3);
f.Color = [1 1 1]
clf
hold on
l = 0;
for str_ind = 1:2
for w = 1:2
fn = sprintf(fn_temp,str{str_ind},t,w)
im = imread(fullfile(ofn_root,fn));
l = l+1;
subplot(2,2,l)
imshow(im)
%title(fn)
drawnow
end
end
saveas(f,['/Users/aidasaglinskas/Desktop/SPMS/' 'comb' num2str(t)],'png')
end

