---
title: Task 1
author: Hendrik Werner
date: \today
fontsize: 12pt
geometry: margin=5em
---

# Problem 1
Conflict set: $\{A_1\}$

There are two independent and gates, with all inputs active ($In_1(A_1), In_2(A_1), In_1(A_2), In_2(A_2)$). Both of them have their output inactive ($\lnot Out(A_1), \lnot Out(A_2)$). If you assume that $\lnot Ab(A_1)$, then there is a conflict, because

$\begin{aligned}
	\lnot Ab(A_1) \land In_1(A_1) \land In_2(A_1) &\leftrightarrow Out(A_1)\\
	true \land true \land true &\leftrightarrow false\\
	true &\leftrightarrow false
\end{aligned}$

# Problem 2
Conflict set: $\{A_1, A_2\}$

# Problem 3