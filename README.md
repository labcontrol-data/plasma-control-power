# plasma-control-power

<p align="center"><a href="http://www.labcontrol.xyz/dokuwiki" target="_blank" rel="noopener"><img src="https://github.com/labcontrol-data/images/blob/main/logo.png"></a></p>

# [Labcontrol, Brazil](http://www.labcontrol.xyz/dokuwiki)

[**Labcontrol**](http://www.labcontrol.xyz/dokuwiki)  is a research laboratory located at Universidade Tecnológica Federal do Paraná (UTFPR), Brazil. UTFPR is a Brazilian public university located in Paraná, Brazil. [**Labcontrol**](http://www.labcontrol.xyz/dokuwiki)  develops research on Control Systems and Automation. The Scientific Director of Labcontrol is [Prof. Dr. Alessandro N. Vargas](http://www.anvargas.com). The projects hosted in [**Labcontrol**](http://www.labcontrol.xyz/dokuwiki)  are [described in this link (click here).](http://www.anvargas.com/blog)

About
============

This page provides information about the project developed at Mesbah lab, UC Berkeley, USA, called ["Low-cost electronics for controlling current and power
in DC plasma reactor."](http://www.anvargas.com/blog/plasma.html)  Experiments were carried out in practice at Mesbah laboratory, and the data contained in this GitHub repository were collected in those experiments. 

[![DOI](https://zenodo.org/badge/577329848.svg)](https://zenodo.org/badge/latestdoi/577329848)

**Please check more details about this project on the page detailing the ["(link soon)"](http://www.anvargas.com/blog/plasma.html)**


`mainCodeMatlab.m` is a MATLAB(R) script that calls Matlab and generates simulation data. The script also generates figures. The figures contain both simulation and real-time data collected in a laboratory testbed.

`mainCodeArduinoDue.ino` is an Arduino Due code. This code processes data that were collected in real-time. The data contains information from low-cost probes that measured high-voltage from a plasma reactor. In addition, current and voltage measurements were taken and processed using an Arduino Due. All code, schematics, and data are available in this repository.

For more details about the experimental data and the corresponding academic publications, please visit [the project page](http://www.anvargas.com/blog).


Installation
============

1. Extract the ZIP file (or clone the git repository) on your computer.
2. Add the folders `code/` and `data/` to your path in MATLAB/Octave: e.g. 
    - using the "Set Path" dialog in MATLAB, or 
    - by running the `addpath` function from your command window or `startup` script.

Make sure that you are running Matlab 2017a (or a newer version). Older versions may work, but it is uncertain.
3. Upload the code `mainCodeArduinoDue.ino`in your Arduino Due using the corresponding IDE interface.

Usage
=====

Typical usage of `mainCodeMatlab.m` consists of running it in your MATLAB. The code generates figures.

MATLAB
------
  1. Run `mainCodeMatlab.m`.

More information
================

* For more information about `mainCodeMatlab.m`, visit the author's page: [Prof. Alessandro N. Vargas](http://www.anvargas.com). You are welcome to help improve the code.
* You are free to use the data in your research. If you do so, please contact the author [Prof. Alessandro N. Vargas](http://www.anvargas.com) 
And let him know about your project. Depending on your research area, the author can help you interpret the data according to your application. The author can also suggest papers and books that can be helpful in your research.

[![DOI](https://zenodo.org/badge/577329848.svg)](https://zenodo.org/badge/latestdoi/577329848)

Citation
------
How to cite the data of this repository:

```
@misc{vargasGithub2023,
    author       = {A. N. Vargas},
    title        = {Data, source code, and documents for low-cost sensors and electronics for plasma experiments}},
    month        = {Dec},
    year         = 2023,
    doi          = {10.5281/zenodo.577329848},
    version      = {1.0.1},
    publisher    = {Zenodo},
    url          = {https://zenodo.org/badge/latestdoi/577329848}
};
```

