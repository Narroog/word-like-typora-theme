# A worked derivation of regularised linear least squares

## Abstract

Linear least squares provides a simple setting for connecting parameter estimation, matrix geometry and regularisation. This article derives a straight-line fit from the residual sum of squares and examines how a slope penalty changes the solution. Centring the observations separates the intercept from the slope and reduces the optimisation problem to a scalar quadratic. The resulting expression establishes uniqueness whenever the input values are not all identical. A matrix formulation then shows that the fitted residual is orthogonal to both columns of the design matrix. For four illustrative observations, the unregularised solution has slope 0.9, intercept 0.9 and residual sum of squares 0.70. A unit penalty reduces the slope to 0.75 and increases the residual sum of squares to 0.8125. This deterministic example demonstrates the trade-off between data fit and coefficient shrinkage without making statistical claims about prediction uncertainty. The derivation also identifies the effects of input scaling and the limits of fitting vertical residuals.

**Keywords:** least squares; linear regression; normal equations; regularisation; orthogonal projection

## 1 Introduction

Straight-line fitting is often introduced as a formula for estimating a slope and an intercept. Its value extends beyond that formula because the same calculation connects optimisation, geometry and numerical computation. The least-squares criterion selects coefficients by minimising the sum of squared differences between observations and model predictions [1].

This article presents a worked derivation of that established criterion and a simple regularised extension. Each analytical result is checked using four explicitly specified observations. The example is intended as a compact theoretical manuscript rather than a report of new experimental findings.

No probability distribution is needed for the algebraic minimisation. Statistical inference would require additional assumptions.

## 2 Model and analytical methods

### 2.1 Residuals and normal equations

Consider $n$ observations $(x_i,y_i)$ with $n\geq 2$. The input values are treated as fixed, and a straight line predicts the response:

$$
\hat y_i=ax_i+b,\qquad e_i=y_i-ax_i-b.
$$

Here, $a$ denotes the slope and $b$ denotes the intercept. The residual measures displacement along the response axis, which distinguishes this model from an orthogonal-distance fit. Ordinary least squares minimises

$$
J(a,b)=\sum_{i=1}^{n}(y_i-ax_i-b)^2.
$$

Differentiating with respect to the two unknown coefficients gives

$$
\begin{aligned}
\frac{\partial J}{\partial a}&=-2\sum_{i=1}^{n}x_i(y_i-ax_i-b),\\
\frac{\partial J}{\partial b}&=-2\sum_{i=1}^{n}(y_i-ax_i-b).
\end{aligned}
$$

At a stationary point, both derivatives vanish. Rearranging produces the normal equations:

$$
\begin{aligned}
a\sum_{i=1}^{n}x_i^2+b\sum_{i=1}^{n}x_i&=\sum_{i=1}^{n}x_i y_i,\\
a\sum_{i=1}^{n}x_i+nb&=\sum_{i=1}^{n}y_i.
\end{aligned}
$$

These equations provide necessary conditions for a minimum. The following centred representation also establishes when that minimum is unique.

### 2.2 Centring and the closed-form solution

Define the sample means and centred sums as

$$
\bar x=\frac{1}{n}\sum_{i=1}^{n}x_i,\qquad
\bar y=\frac{1}{n}\sum_{i=1}^{n}y_i,
$$

$$
\begin{aligned}
S_{xx}&=\sum_{i=1}^{n}(x_i-\bar x)^2,\\
S_{xy}&=\sum_{i=1}^{n}(x_i-\bar x)(y_i-\bar y),\\
S_{yy}&=\sum_{i=1}^{n}(y_i-\bar y)^2.
\end{aligned}
$$

The second normal equation implies $b=\bar y-a\bar x$. Thus, for any chosen slope, the best intercept makes the fitted line pass through the mean observation. Substituting this intercept into the objective yields

$$
\begin{aligned}
J_c(a)&=J(a,\bar y-a\bar x)\\
&=\sum_{i=1}^{n}\big[(y_i-\bar y)-a(x_i-\bar x)\big]^2\\
&=S_{yy}-2aS_{xy}+a^2S_{xx}.
\end{aligned}
$$

When $S_{xx}>0$, differentiation gives the familiar coefficient estimates:

$$
\boxed{\hat a=\frac{S_{xy}}{S_{xx}},\qquad
\hat b=\bar y-\hat a\bar x.}
$$

Completing the square shows how the objective changes when the slope moves away from its optimum:

$$
J_c(a)=S_{xx}(a-\hat a)^2+S_{yy}-\frac{S_{xy}^2}{S_{xx}}.
$$

The first term is non-negative and vanishes only at $a=\hat a$. Therefore, the minimum residual sum of squares is

$$
J_{\min}=S_{yy}-\frac{S_{xy}^2}{S_{xx}}.
$$

### 2.3 Uniqueness and a degenerate input

The Hessian provides an equivalent check on uniqueness:

$$
H=2\begin{pmatrix}
\sum_i x_i^2 & \sum_i x_i\\
\sum_i x_i & n
\end{pmatrix},\qquad
\det H=4nS_{xx}.
$$

If at least two input values differ, then $S_{xx}>0$ and the Hessian is positive definite. The stationary point is consequently the unique global minimum.

If every input equals a constant $c$, the observations constrain only the combination $ac+b$. Any coefficients satisfying $ac+b=\bar y$ attain the same minimum. A unique slope cannot then be recovered from the data alone.

### 2.4 Matrix form and residual geometry

Let $\boldsymbol y$ collect the observed responses, and define the design matrix and coefficient vector by

$$
X=\begin{pmatrix}
x_1&1\\
x_2&1\\
\vdots&\vdots\\
x_n&1
\end{pmatrix},\qquad
\boldsymbol\theta=\begin{pmatrix}a\\b\end{pmatrix}.
$$

The objective and its stationarity condition become

$$
J(\boldsymbol\theta)=\lVert\boldsymbol y-X\boldsymbol\theta\rVert_2^2,
\qquad X^{\mathrm T}X\hat{\boldsymbol\theta}=X^{\mathrm T}\boldsymbol y.
$$

For full column rank, the formal solution is $(X^{\mathrm T}X)^{-1}X^{\mathrm T}\boldsymbol y$. This expression is useful analytically; numerical implementations should use an appropriate least-squares solver rather than explicitly constructing the inverse [2].

Writing the fitted residual as $\boldsymbol r=\boldsymbol y-X\hat{\boldsymbol\theta}$ gives

$$
X^{\mathrm T}\boldsymbol r=\boldsymbol 0
\quad\Longleftrightarrow\quad
\sum_{i=1}^{n}r_i=0,\qquad\sum_{i=1}^{n}x_i r_i=0.
$$

The fitted response is therefore the orthogonal projection of the observation vector onto the column space of $X$. Residuals need not vanish individually; their aggregate components along the constant and input columns vanish.

## 3 Slope regularisation

A quadratic penalty discourages large slopes while retaining a freely fitted intercept. For a positive penalty parameter $\lambda$, consider

$$
J_\lambda(a,b)=J(a,b)+\lambda a^2.
$$

Because the intercept is unpenalised, its stationarity condition remains $b_\lambda=\bar y-a_\lambda\bar x$. The centred objective is consequently

$$
J_{\lambda,c}(a)=S_{yy}-2aS_{xy}+(S_{xx}+\lambda)a^2.
$$

Its strictly positive quadratic coefficient gives

$$
\boxed{a_\lambda=\frac{S_{xy}}{S_{xx}+\lambda},\qquad
b_\lambda=\bar y-a_\lambda\bar x.}
$$

For $S_{xx}>0$, this slope is a scaled version of the ordinary least-squares estimate:

$$
a_\lambda=\frac{S_{xx}}{S_{xx}+\lambda}\hat a.
$$

Increasing the penalty moves the slope towards zero. In the limit, the model predicts the mean response at every input:

$$
\lim_{\lambda\to\infty}a_\lambda=0,\qquad
\lim_{\lambda\to\infty}b_\lambda=\bar y.
$$

The intercept condition still gives zero mean residual. The slope condition, however, changes to $\sum_i x_i r_{\lambda,i}=\lambda a_\lambda$. Ordinary residual orthogonality to the input column therefore does not generally hold after penalisation.

## 4 Numerical verification

Table 1 specifies a deterministic dataset and the unregularised fit. These four observations are illustrative values rather than measurements from an experiment.

**Table 1. Observations, fitted responses and ordinary least-squares residuals.**

| Observation | Input $x_i$ | Response $y_i$ | Fit $\hat y_i$ | Residual $r_i$ |
| --- | --- | --- | --- | --- |
| 1 | 0 | 1 | 0.9 | 0.1 |
| 2 | 1 | 2 | 1.8 | 0.2 |
| 3 | 2 | 2 | 2.7 | −0.7 |
| 4 | 3 | 4 | 3.6 | 0.4 |

The means and centred sums are

$$
\bar x=1.5,\quad\bar y=2.25,\quad
S_{xx}=5,\quad S_{xy}=4.5,\quad S_{yy}=4.75.
$$

Substitution gives $\hat a=0.9$ and $\hat b=0.9$. The minimum objective agrees with the directly calculated residual sum:

$$
J_{\min}=4.75-\frac{4.5^2}{5}
=0.1^2+0.2^2+(-0.7)^2+0.4^2=0.70.
$$

Both orthogonality conditions can also be checked directly:

$$
\begin{aligned}
\sum_i r_i&=0.1+0.2-0.7+0.4=0,\\
\sum_i x_i r_i&=0(0.1)+1(0.2)+2(-0.7)+3(0.4)=0.
\end{aligned}
$$

With $\lambda=1$, the regularised coefficients become $a_1=0.75$ and $b_1=1.125$. Table 2 compares both fits under the same unit-penalty objective.

**Table 2. Coefficients and objectives evaluated at the two fitted solutions.**

| Quantity | Ordinary fit | Unit-penalty fit |
| --- | --- | --- |
| Slope | 0.9 | 0.75 |
| Intercept | 0.9 | 1.125 |
| Residual sum of squares $J$ | 0.70 | 0.8125 |
| Unit penalty $a^2$ | 0.81 | 0.5625 |
| Penalised objective $J+a^2$ | 1.51 | 1.375 |

The penalty increases the unpenalised residual sum by 0.1125 while reducing the squared slope by 0.2475. Their combined change lowers the penalised objective by 0.135. This comparison concerns the stated optimisation criterion and does not establish improved prediction on unseen observations.

## 5 Discussion

The penalty has a scale-dependent interpretation. Rescaling the input changes the numerical slope, so retaining the same numerical penalty generally changes the fitted predictions. Input units or a defined standardisation procedure must therefore accompany the penalty value.

Three further boundaries matter. First, vertical residuals treat the input values as exact and do not model input measurement error. Second, squared residuals can give large deviations substantial influence, a recognised limitation of least-squares fitting [1]. Third, a small training residual alone does not justify extrapolation beyond the observed input range.

For larger problems, matrix rank and residual accuracy also require attention. The NumPy least-squares interface returns coefficients, residual information, rank and singular values [2], which support these checks.

## 6 Conclusions

The centred objective yields a unique straight-line fit whenever the inputs contain at least two distinct values. Its matrix form explains residual orthogonality, while a slope penalty gives an explicit shrinkage factor. The example verifies both solutions and quantifies their trade-off between data fit and coefficient magnitude.

## Data availability

All observations and numerical results are included in Tables 1 and 2. No external dataset is required to reproduce the calculations.

## References

1. NIST/SEMATECH. *e-Handbook of Statistical Methods*, Section 4.1.4.1: [Linear Least Squares Regression](https://www.itl.nist.gov/div898/handbook/pmd/section1/pmd141.htm).
2. NumPy Developers. [numpy.linalg.lstsq](https://numpy.org/doc/stable/reference/generated/numpy.linalg.lstsq.html). NumPy documentation.
