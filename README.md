# slurm_array

## Get the code:

- Do `git clone git@gitlab.oit.duke.edu:dpb6/slurm_iat.git` 
- Or download the ZIP file from https://gitlab.oit.duke.edu/dpb6/slurm_iat

## Run a single alignment:

1. Put the JPGs into `./IMAGES/`
2. Try running `myFeatureBasedAlignment.m` in MATLAB with `a=2;` and `ifplot=1;` (I didn't try this yet, it might fail)
3. The `./output` folder should contain a MAT file with your rotated image.
4. You can make it save a JPG instead. If you are feeling generous, add the code to the repo via a merge request (want some practice with git?)

## Parallel processing using a SLURM script on a computer cluster:

If you are feeling lucky, set up a SLURM array job:
  1. In `launch.sh` set the array to be 1-N where N is the number of images.
  2. Set the appropriate SLURM parameters in `array_job.sh`
  3. Launch it on the cluster to warp all the frames to the first one.