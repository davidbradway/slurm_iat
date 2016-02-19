% 'a' contains the SLURM_ARRAY_TASK_ID
N=a;

cd('iatool'); iat_setup;

cd('../IMAGES'); file = dir('*.JPG');

clc; close all;

ifplot=0;

%% Load and show images
% Read image <-> template pair
template=imread(file(1).name);
imageN=imread(file(N).name);

transform = 'affine'; % it can be approximated by euclidean as well

if(ifplot)
    % Plot both of these images
    figure; imshow(imageN); title('Image','Fontsize',14);
    figure; imshow(template); title('Template','Fontsize',14);
end

%% Feature-based alignment
% Extract SURF descriptors
[d1, l1]=iat_surf(imageN);
[d2, l2]=iat_surf(template);

% Match keypoints
disp('Match keypoints')
%[map, matches, imgInd, tmpInd]=iat_match_features(d1,d2,.7);
[map, matches, imgInd, tmpInd]=iat_match_features_mex(d1,d2,.7);
disp('Finish Match keypoints')

ptsA=l1(imgInd,1:2); ptsB=l2(tmpInd,1:2);

% RANSAC
[inliers, ransacWarp]=iat_ransac(iat_homogeneous_coords(ptsB'),iat_homogeneous_coords(ptsA'),...
                                 transform,'tol',.05, 'maxInvalidCount', 10);

if(ifplot)
    % Plot initial correspondences
    iat_plot_correspondences(imageN,template,ptsA',ptsB');
    title('Initial correspondences','Fontsize',14);

    %Plot filtered correspondences
    iat_plot_correspondences(imageN,template,ptsA(inliers,:)',ptsB(inliers,:)');
    title('RANSAC-filtered correspondences','Fontsize',14);
end

% Compute the warped image and visualize the error
disp('Warp image')
[wimage, support] = iat_inverse_warping(imageN, ransacWarp, transform, 1:size(template,2),1:size(template,1));

disp('Write JPG')
imwrite(uint8(wimage),['../output/' file(N).name])

if(ifplot)
    %plot the warped image
    figure; imshow(uint8(wimage)); title('Warped image by feature-based alignment (RANSAC)', 'Fontsize', 14);

    % visualize the error
    [imdiff, grayerror] = iat_error2gray(template,wimage,support);
    figure; imshow(grayerror); title('Error of RANSAC feature-based alignment ', 'Fontsize', 14);
end

cd ..

%%
