# Multi-output-GP
Multi-output Gaussian Process

This project could be used for solving both spatial-temporal problem/dynamic problem and multi-output problem.

Based on Conti S, O’Hagan A. Bayesian emulation of complex multi-output and dynamic computer models[J]. Journal of statistical planning and inference, 2010, 140(3): 640-651.

---
### The code usage:
1. Download **RichardPoFlow**(https://github.com/xingle/RichardPoFlow) as the libraries to generate data.
2. Run **Richard1dDataGen_Script** file at root and save generated data.
3. Run **DEMO_mogp** file at root for demonstrations.

**The code is still under development.**

---
### Demo result short-view
The demo uses 350 sets of training data to optimise parameter r, then predicts the test data and compares the result with the origin data in both spatial-temporal map and uncertainty quantification(UQ) map.

![avatar](https://github.com/ZhengXing-shawn/Multi-output-GP/blob/master/gif/350Tr_20Te_3nKl_05timestep_Time.gif)
- The **Dashed line** represents the **prediction** results.
- The **Solid line** represents the **origin** data.


![avatar](https://github.com/ZhengXing-shawn/Multi-output-GP/blob/master/gif/350Tr_20Te_3nKl_05timesstep_UQ.gif)
- The **blue line** represents the error bar of prediction result.
- The **yellow line** represents the error bar of origin data.
