When running Python jobs on Quest, you need to install the packages first before importing them in your scripts.  You can do this from a Quest login node.  

Load the version of Python you want to use:
```
module load python/anaconda3.6
```

Then install packages `pip`, specifying the `--user` option.  
```
pip install --user <packagename>
```

Remember NOT to surround the name with `<>`.

The packages you install will then be available on the compute nodes when your job runs.  Make sure to load the same Python module you used to install the packages.

If you want to use virtual environments or conda environments, please contact quest-help@northwestern.edu for assistance.

The conda package manager currently has some conflicts between our central Python distribution installation and user environments.  Please use `pip` instead or contact Research Computing for assistance.

If you have difficulty installing a package, please contact quest-help@northwestern.edu for assistance.