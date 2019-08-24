## We have updated the code on Oct 5, 2018. Now, the performance is the same as in our paper.

The code is for the work (it achieves the state-of-the-art perfromance for patch based face super-resolution):

````
@inproceedings{jiang2017context,
  title={Context-patch based face hallucination via thresholding locality-constrained representation and reproducing learning},
  author={Jiang, Junjun and Yu, Yi and Tang, Suhua and Ma, Jiayi and Qi, Guo-Jun and Aizawa, Akiko},
  booktitle={ICME 2017},
  pages={469--474},
  year={2017},
  organization={IEEE}
}

@article{jiang2018context,
  title={Context-Patch Face Hallucination Based on Thresholding Locality-constrained Representation and Reproducing Learning},
  author={Jiang, Junjun and Yu, Yi and Tang, Suhua and Ma, Jiayi and Aizawa, Akiko and Aizawa, Kiyoharu},
  journal={IEEE Transactions on Cybernetics},
  year={2018}
}
````



You can run the Demo_TLcR_RL.m


Note that all the results in our paper were conducted in MATLAB R2014a.


We also provide the results of all comparison methods, including Wang et al.'s method [16], NE [14], LSR [4], SR [5], LcR [6], LINE [15], SRCNN [9], TLcR, and the proposed TLcR-RL, in the file of 'other results'.

Demo_other_methods.m is implementation of Wang et al.'s method [16], NE [14], LSR [4], SR [5], LcR [6], and LINE [15].
