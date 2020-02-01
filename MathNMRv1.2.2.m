(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage["MathNMR`"]


Print["------------------------------------"];
Print["MathNMR v. 1.2.2: Spatial and Spin Tensor Manipulations in Mathematica"];
Print["by Alexej Jerschow (2005)"];
Print["J. Magn. Reson. 176 (2005) 7-14"];
Print["type \"?commands\" for a list of commands"];
Print["type \"?<command>\" for a more detailed description of a command"];
Print["type \"?changes\" for a description of changes made in this vesion."];
Print["------------------------------------"];

changes::usage="\<
Version 1.1: fixed sign problem in Cartesian operators and spherical tensors. Also fixed sign problem in rotations. The main changes flow from the change of the reversal of the labeling of both columns and rows, so that the highest m value is at the first column/row. 
new function: tensorin

Version 1.2: fixed minor errors when running on Mathematica v. 9.0

Version 1.2.2: added support for CSA antisymmetric tensor interaction for relaxation

\>";
commands::usage="\<
Type ?command for a more detailed description of a command

Setting up the spin system:
  setSpinSys[spinlist]
  setSpinSys[spinlist,flist,hamiltonianlist]

Spin operators
  ispinT[i,L,M]
  ispinC[i,x]  (same with y, z, p, m, e)
  ispinST[i,m1,m] single trans.op.

  convertTtoPM[opexpr] convert spherical tensors into raising and lowering ops.

  spinT[{L1,M1},{L2,M2},...]
  spinC[x,y,...]
  toispin[op] converts spin expressions to ispin


Matrix representation, commutators, decomposition, projection, coherence filtering:
  mrep[opexpr]
  commutator[mtx1,mtx2]
  spinTDecomposition[mtx]
  spinCDecomposition[mtx]
  spinTCommutator[opA,opB]
  spinCCommutator[opA,opB]
  projectionOp[oplist,mtx]
  oneMinusProjectionOp[oplist,mtx]
  filterCoherence[{p1,p2,...},opexpr] filtering operator expressions.
  cohfltM[{p1,p2,...}] for filtering matrices 

Hamiltonians:
  makeHJ[i,j]
  makeHCSA[i]
  makeHD[i,j], makeHD[i,j,m]
  makeHCSiso[i]
  makeHQ[i]

Spatial Tensors
  wD[{i,j},m] dipolar coupling tensor
  wQ[i,m] quadr. coupling tensor
  wcsa[i,m] CSA tensor
  makeSpatialD[wd,i,j,wD,a,b,g]
  makeSpatialCSA[wcsa,i,\[Delta],\[Eta],a,b,g]
  makeSpatialQ[wq,i,\[Delta],\[Eta],a,b,g]
  copyTensor[a,b]

Symbols
  x,y,z Cartesian operator component subscripts
  p,m: raising and lowering op. subscripts.
  e: subscript for identity op.
  wD[{i,j},m] dipolar coupling tensor
  wQ[i,m] quadr. coupling tensor
  wcsa[i,m] CSA tensor
  J[i,j]  scalar coupling constant
  sdfJ[int1,int2,frequ]: cross-correlation spectral density function.

Rotations and pulses
  pulse[mtx,i,\[Alpha],\[Phi],\[Psi]]
  rotateSpatial[w,idx,a,b,g] rotate spatal tensors
  spinRotMtx[i,a,b,g] spin tensor rotation matrix
  wignerRotMtx[L,a,b,g] wigner rot. matrix
  wignerD[L,m1,m,a,b,g] wigner rot. element
  reducedD[L,m1,m,b] reduced wigner element
  dER[L,m1,m,b,n1,n2,n3] Euler-Rodriguez rotation element

Matrix operations and functions
  dagger[mtx]: Hermitian conjugate matrix.
  calcnorm[mtx]: calculates the norm of a matrix.

Redfield coefficients
  RedfieldCoeff[op1,op2]
  sdfJ[int1,int2,frequ]: cross-correlation spectral density function.

Evolution, Acquisition, Spectra
  evolve[rhomtx,Hmtx,t]
  acquire[rhomtx,Hmtx,dt,obs,N]
  {scale,spec}=getspec[rhomtx,Hmtx,obsmtx,N,frange]
  ftshift[spec]: shift frequency origin to center.
  plotspec[spec]
  plotspec[scale,spec]
  plotspecIm[spec]: plots imaginary part of spectrum.
  plotspecIm[scale,spec]
  speclb[spec,lb]: add line broadening to spectrum (by IFT, EM, then FT).

Single spin matrix forms:
  sphtens[L,M,S] spherical tensors single spin.
  sphtens[L,M,S,normfun] spherical tensors, single spin.
  cohfltSingleSpin[S,p] coherence filter mask for single spin S. 
  mtxST[S,m1,m] matrix for single transition for single spin. 
  IxOp[S]
  IyOp[S]
  IzOp[S]
  IpOp[S]
  ImOp[S]

Matrix manipulations:
  MF[mtx] same as MatrixForm  unitE: identity matrix in full Hilbert space.
  zero: zero matrix in full Hilbert space.
  crossProd[A,B]: outer produce
  crossProdGeneral[f,A,B]: general outer product.
  
Miscellaneous:
  expandDot[expr] expand dot product according to distributive laws.
  orderDot[expr] order dot product according to increasing spin indices.
  getnspins: return the number of spins.
\>";


setSpinSys::usage=
"setSpinSys[spinlist]: Set up the spin system. \"spinlist\" is a list of spin values of the different spins in the system.\n
setSpinSys[spinlist,flist,hamiltonianlist]: This form is used in connection with the calculation of Refield elements. \"flist\" is a list of the Larmor frequencies of the different spins. \"hamiltonianlist\" is a list of the Hamiltonians to be stored for Redfield calculations. Example: hamiltonianlist={\"DD\", 1, 2, \"CSA\", 2, \"Q\", 1} means that the Hamiltonians for dipolar coupling between spins 1 and 2, the one for chemical shift anisotropy for spin 2, and the one of the quadrupolar coupling of spin 1 will be internally stored. These will be used for Redfield calculations."
copyTensor::usage="copyTensor[a,b]. Use this function to copy a spatial tensor.";
mrep::usage="mrep[expr]. Converts all expressions with spin operator components into their respective matrix representations. You need to set up the spin system with \"setSpinSys\" first.";
spinTDecomposition::usage="spinTDecomposition[mtx]. Decomposes a matrix in the spherical tensor product operator basis.";
spinCDecomposition::usage="spinCDecomposition[expr]. Decomposes a matrix in the cartesian product operator basis.";
spinTCommutator::usage="spinTCommutator[opA,opB]. Calculates the commutator between two operator expressions and represents it in terms of spherical tensors.";
spinCCommutator::usage="spinCCommutator[opA,opB]. Calculates the commutator between two operator expressions and represents it in terms of cartesian tensors.";
spinT::usage="spinT[{L1,M1},{L2,M2},...]. Product operator for spin system composed of the individual spherical tensor operators of individual spins with rank Li and order Mi.";
spinC::usage="spinC[a,b,...]. Product operator for spin system composed of the individual cartesian tensor operators. a, b, etc. can be x, y, z, or e (the latter for the identity matrix).";
ispinT::usage="ispinT[i,L,M]. Individual spherical i-th spin operator of rank L and order M (within the basis of the full spin system).";
ispinC::usage="ispinC[i,a]. Individual cartesian i-th spin operator (within the basis of the full spin system). a can be x, y, z, or e (e is the identity operator).";
ispinST::usage="ispinST[i,m1,m]. Single transition i-th spin operator between levels m1 and m.";
toispin::usage="toispin[expr]. Convert expressions containing spinT and spinC operators into expressions containing products of ispinT and ispinC operators.";
x::usage="x cartesian component.";
y::usage="y cartesian component.";
z::usage="z cartesian component.";
e::usage="e cartesian component for the identity operation";
p::usage="p (plus): index for the raising operator.";
m::usage="m (minus): index for the lowering operator.";
makeHJ::usage="makeHJ[i,j] produces the scalar coupling Hamiltonian between spins i and j in angular frequency units.";
makeHDD::usage="makeHDD[i,j], makeHDD[i,j,m]: produce the dipolar Hamiltonians between spins i and j of order m. makeHDD[i,j] produces the full dipolar Hamiltonian. The expressions are given in angular frequency units.";
makeHCSiso::usage="makeHCSiso[i] creates the isotropic chemical shift Hamiltonian for spin i in angular frequency units.";
makeHCSA::usage="makeHCSA[i] creates the chemical shift anisotropy Hamiltonian for spin i in angular frequency units.";
makeHQ::usage="makeHQ[i] creates the quadrupolar Hamiltonian for spin i in angular frequency units.";
(*MakeV::usage="MakeV use depreciated.";
MakeVbilin::usage="MakeVbilin use depreciated.";
MakeDDHamiltonian::usage="MakeDDHamiltonian use depreciated";
*)
projectionOp::usage="projectionOp[oplist,mtx]. Projects matrix \"mtx\" onto the space described by the operator expressions in the list \"oplist\".";
oneMinusProjectionOp::usage="oneMinusProjectionOp[oplist,mtx]. Identity operation minus projectionOp[oplist,mtx]. Projects mtx onto the space outside of the space spanned by the list of operators given in oplist.";
dagger::usage="dagger[mtx]: Hermitian conjugate of a matrix.";
calcnorm::usage="calcnorm[op]: calculates the norm of an operator expression.";
tensorin::usage=
"tensorin[op,mtx]: calculaes how much of the operator op is contained in matrix mtx";
getspinsys::usage=
"getspinsys[i]: get the spin value of the i-th spin.";
getnspins::usage="getnspins gives the number of spins in the spin system (previously set up via the setSpinSys command.";
RedfieldCoeff::usage="RedfieldCoeff[op1,op2] calculates the Redfield coefficient between op1 and op2 based on the spin system, frequencies and Hamiltonians supplied in \"setSpinSys\".";
sdfJ::usage="sdfJ[int1,int2,frequ]: (Cross-correlation) spectral density function between the interactions in \"int1\" and \"int2\" at the frequency \"frequ\". \"int1\" and \"int2\" are expressions of the form {\"D\",i,j}, {\"Q\",i}, or {\"CS\",i}.";
wD::usage="wD[{i,j},m]: dipolar coupling constant between spin i and j of order m in angular frequency units.";
wiso::usage="wiso[i]: isotropic chemical shift of spin i in angular frequency units.";
wcsa::usage="wcsa[i,m]: chemical shift anisotropy spatial tensor component of order m for spin i in angular frequency units.";
wQ::usage="wQ[i,m]: quadrupolar spatial tensor component of order m for spin i in angular frequency units.";
J::usage="J[i,j]. Scalar coupling constant between spins i and j in units of Hertz!.";
convertTtoPM::usage="convertTtoPM[opexpr]: converts operator expressions containing terms of the ispinT form into operators expressed by p, m, and z (raising, lowering, and z).";
expandDot::usage="expandDot[expr]: Expand dot product to bring out constant factors in the front, and to apply distributivity.";
orderDot::usage=
"orderDot[expr]: order ispinT and ispinC operators in dot products such that the spin indices of the operators increase from left to right. It is recommended to use expandDot before applying this function.";
dER::usage="dER[L,m1,m,b,n1,n2,n3]: Euler-Rodriguez parameterized rotation matrix (m1,m)-element for rank L, angle b, and along the axis oriented along the unit vector specified by n1, n2, n3 (see paper).";
reducedD::usage="reducedD[L,m1,m,b]: reduced Wigner rotation matrix (m1,m) element for rank L, angle b.";
wignerD::usage="wignerD[L,m1,m,a,b,g]: Wigner rotation matrix (m1,m) element for angles a, b, g and rank L.";
wignerRotMtx::usage="wignerRotMtx[L,a,b,g]: full Wigner rotation matrix for rank L and angles a,b,g.";
spinRotMtx::usage="spinRotMtx[i,a,b,g]: i-th spin rotation matrix in the full product space. Wigner rotation angles a,b,g.";
sphtens::usage="sphtens[L,M,S], sphtens[L,M,S,normfun]: Spherical tensor of rank L, order M for a spin value S. \"normfun\" is the function used for normalizing the tensors, either \"a\" or \"b\" referring to the normalizations given in the paper. \"b\" is the default if \"normfun\" is omitted. If a letter other than \"a\" or \"b\" is used no normalization function is applied.";
IzOp::usage="IzOp[S] gives the Iz matrix representation for a spin value S.";
IpOp::usage="IpOp[S] gives the I_+ matrix representation for a spin value S.";
ImOp::usage="ImOp[S] gives the I_- matrix representation for a spin value S.";
IxOp::usage="IxOp[S] gives the Ix matrix representation for a spin value S.";
IyOp::usage="IyOp[S] gives the Iy matrix representation for a spin value S.";
crossProdGeneral::usage="crossProdrodGeneral[f,A,B], generalized outer product for two matrices A and B. f[a,b] is a function for combining two numbers.";
crossProd::usage="crossProd[A,B], outer product for the matrices A and B."
commutator::usage=
"commutator[A,B]=A.B-B.A.";
makeSpatialD::usage="makeSpatialD[wd,i,j,wD,a,b,g]: creates the second-rank spatial tensor in the variable \"wd\" for the dipolar coupling between spins i and j. The coupling constant wD (in the PAS) is given in angular frequency units, and is rotated from the PAS by the Wigner angles a, b, g.";
makeSpatialCSA::usage="makeSpatialCSA[wcsa,i,\[Delta],\[Eta],a,b,g]: creates the second-rank spatial tensor for the CSA interaction of spin i in the variable \"wcsa\". The coupling constant in the PAS is \[Delta] (in Radians/s), the anisotropy \[Eta], and the tensor is rotated from the PAS by the Wigner angles a, b, g.";
makeSpatialQ::usage="makeSpatialQ[wq,i,\[Delta],\[Eta],a,b,g]: creates the second-rank spatial tensor for the quadrupolar interaction of spin i in the variable \"wcsa\".The coupling constant in the PAS is \[Delta] (in Radians/s),the anisotropy \[Eta], and the tensor is rotated from the PAS by the Wigner angles a,b,g.";
unitE::usage=
"Identity matrix for spin system. Output as \"Id\".";
zero::usage=
"Zero mtx for spin system";
mtxST::usage="mtxST[S,m1,m]: Single transition operator for a given spin value S between the levels m1 and m.";
cohfltM::usage=
"cohfltM[{p1,p2,...}]: returns a matrix for the full Hilbert space which acts as a mask for filtering coherence p1 for spin 1, p2 for spin 2, etc. Instead of a coherence order one may also supply the keyword \"any\", which means that for the given spin any coherence order will be considered. To filter the coherence components from a matrix mtx one would write: cohfltM[{p1,p2,...}]*mtx. For filtering coherences from operator expressions use filterCoherence.";
filterCoherence::usage=
"filterCoherence[{p1,p2,...},opexpr]: filters coherences from the operator expression opexpr. Filters the terms that correspond to p1 coherence for spin 1, p2 coherence for spin 2, etc. Instead of pi one may also write the keyword \"any\" which will then allow any coherence order for the particular spin. For filtering matrices use the cohfltM command.";
any::usage=
"any: keyword used in cohfltM and filterCoherence to designate any coherence order.";
cohfltSingleSpin::usage=
"cohfltSingleSpin[S,p]: returns a coherence filter mask matrix for a spin value of S and coherence order p.";
MF::usage="MF is short for Mathematica's MatrixForm command.";
rotateSpatial::usage=
"rotateSpatial[w,idx,a,b,g]: Rotates the spatial tensor w by the Wigner angles a, b, g. idx is the index of the spin for single-spin interactions (quadrupolar, CSA), or a list with two indices (for the dipolar interaction). For example, to rotate the dipolar coupling tensor of spins 1 and 3 use rotateSpatial[wD,{1,3},a,b,g].";
pulse::usage=
"pulse[mtx,i,\[Alpha],\[Phi],\[Psi]]: Executes an rf pulse on the matrix mtx, acting on spin i, flip angle \[Alpha], phase \[Phi]. The effective field is tilted by the angle \[Psi] off the transverse plane (for off-resonance pulses). If \[Psi]=0 it's an on-resonance pulse.";
evolve::usage=
"evolve[rhomtx,Hmtx,t]: Evolve matrix expression rhomtx under the Hamiltonian Hmtx (matrix rep, units of rad/s) for time t.";
acquire::usage=
"acquire[rhomtx,Hmtx,dt,obs,N]: Returns N data points from evolving the matrix expression rhomtx (matrix rep) under the Hamiltonian Hmtx (matrix rep, units of rad/s) with time intervals dt and detection operator obsmtx (in matrix representation).";
getspec::usage="{scale,spec}=getspec[rhomtx,Hmtx,obsmtx,N,frange]: Calculate spectrum in the frequency domain directly (see paper). rhomtx is the initial density operator, Hmtx the Hamiltonian (units of rad/s), obsmtx the detection operator, N the number of points in the spectrum, and frange={fmin,fmax} specifies the frequency range to cover in the spectrum. All operators are supplied in the matrix representation. Returns the frequency scale as well as the spectrum.";
ftshift::usage=
"ftshift[spec]: shift frequency origin to center of spectrum (usually done after Fourier Transformation using the command Fourier.";
plotspec::usage=
"plotspec[spec], plotspec[scale,spec]: plots the real part of the spectrum either with or without scale.";
plotspecY::usage="plotspecY[spec], plotspecY[scale,spec]: plots the real part of the spectrum either with or without scale, includes Y axis.";
plotspecIm::usage=
"plotspecIm[spec], plotspecIm[scale,spec]: plots imaginary part of the spectrum either with or without scale.";
speclb::usage=
"speclb[spec,lb]: Performs linebroadening on the spectrum in the time domain by exponential multiplication according to fid*Exp[-t*lb/T], where T is the total acquisition time.";


Begin["`Private`"]


Off[ClebschGordan::phy];
MF[a_]:=MatrixForm[a];
sphtens[L_,M_,spin_,normfun_]:=Module[{normf},normf=Simplify[If[normfun=="b",L!*Sqrt[(2*spin+L+1)!/(2^L*(2*L)!*(2*spin-L)!*(2*spin+1))],If[normfun=="a",Sqrt[(2*L+1)/(2*spin+1)],1]]];
Return[normf Table[ClebschGordan[{spin,m1},{L,M},{spin,m}],{m,spin,-spin,-1},{m1,spin,-spin,-1}]]];
sphtens[L_,M_,spin_]:=sphtens[L,M,spin,"b"];
dagger[a_]:=Transpose[ComplexExpand[Conjugate[a]]];

cohfltSingleSpin[spin_,p_]:=Module[{dummy},
If[p===any,
Return[Table[1,{m,-spin,spin},{m1,-spin,spin}]],Return[Table[If[m1==m+p,1,0],{m,-spin,spin},{m1,-spin,spin}]]];
];

(*IzOp[spin_]:=DiagonalMatrix[Table[m,{m,spin,-spin,-1}]];*)
IzOp[spin_]:=sphtens[1,0,spin];
IpOp[spin_]:=-Sqrt[2]sphtens[1,1,spin];
(*IpOp[spin_]:=Table[If[m1\[Equal]m+1,Sqrt[spin(spin+1)-m(m+1)],0],{m,spin,-spin,-1},{m1,spin,-spin,-1}];*)
(*ImOp[spin_]:=Table[If[m1\[Equal]m-1,Sqrt[spin(spin+1)-m(m-1)],0],{m,spin,-spin,-1},{m1,spin,-spin,-1}];*)
ImOp[spin_]:=Sqrt[2]sphtens[1,-1,spin];
IxOp[spin_]:=(IpOp[spin]+ImOp[spin])/2;
IyOp[spin_]:=(-I/2)(IpOp[spin]-ImOp[spin]);

crossProdGeneral[f_,xx_,yy_]:=Module[{i,j},With[{dx=Dimensions[xx],dy=Dimensions[yy]},If[NumberQ[xx]||NumberQ[yy],Return[f[xx yy]],Return[Table[f[xx[[(Floor[(i-1)/dy[[1]]]+1),(Floor[(j-1)/dy[[2]]]+1)]],yy[[(Mod[(i-1),dy[[1]]]+1),(Mod[(j-1),dy[[2]]]+1)]]],{i,1,dx[[1]]*dy[[1]]},{j,1,dx[[2]]*dy[[2]]}]]]]];

crossProd[xx_,yy_]:=Module[{i,j},With[{dx=Dimensions[xx],dy=Dimensions[yy]},If[NumberQ[xx]||NumberQ[yy],Return[xx yy],Return[Table[xx[[(Floor[(i-1)/dy[[1]]]+1),(Floor[(j-1)/dy[[2]]]+1)]]*yy[[(Mod[(i-1),dy[[1]]]+1),(Mod[(j-1),dy[[2]]]+1)]],{i,1,dx[[1]]*dy[[1]]},{j,1,dx[[2]]*dy[[2]]}]]]]];

commutator[A_,B_]:=Simplify[A.B-B.A];


setSpinSys[sys_,frequ1_,Hlist_]:=Module[{dummy},
nspins=Length[sys];
spinsys=sys;
frequencies=frequ1;

basisMTX=.;
basisMTXCart=.;
(*basis=MakeBasis;
basisCart=MakeCartesianBasis;
basisMTX=mrep[basis];
basisMTXCart=mrep[basisCart];
*)

HamSpinTList=MakeAllHamiltonians[Hlist];

HamMList=mrep[HamSpinTList];

HamFrequSign=Map[frequ,HamSpinTList];
HamFrequ=Map[makePositFrequ,Map[frequ,HamSpinTList]];
HamCohord=Map[cohord,HamSpinTList];
unitEMTX=mrep[ispinT[1,0,0]];
zeroMTX=mrep[ispinT[1,0,0]]*0;
Return[spinsys];
];


setSpinSys[sys_]:=setSpinSys[sys,{},{}];


getspinsys[i_]:=spinsys[[i]];


getnspins:=nspins;


possibsingleS[S_]:=Flatten[Table[Table[{L,M},{M,-L,L}],{L,0,2S}],1];
MakeBasis:=
Module[{dummy,dummyMTX,normf},
dummy=Table[possibsingleS[spinsys[[i]]],{i,nspins}];dummy=Apply[spinT,Distribute[dummy,List],1];
normf=Map[calcnorm[mrep[#]]&,dummy];
       Return[(1/normf)*dummy];
];


copyTensor[a_,b_]:=Module[{dummy},DownValues[b]=(DownValues[a]/.a:>b);];


calcnorm[b_]:=Module[{dummy},dummy=mrep[b];
Sqrt[Tr[Conjugate[Transpose[dummy]].dummy]]];


calcnormSQR[b_]:=Module[{dummy},dummy=mrep[b];
Tr[Conjugate[Transpose[dummy]].dummy]];


tensorin[b_,m_]:=Module[{dummy},
dummy=mrep[b];
Tr[Conjugate[Transpose[dummy]].m]/Tr[Conjugate[Transpose[dummy]].dummy]];


MakeCartesianBasis:=
(* only works for spin 1/2 in this way *)
Module[{dummy,dummyMTX,normf},dummy=Table[{e,x,y,z},{i,nspins}];
dummy=Apply[spinC,Distribute[dummy,List],1];
normf=Map[calcnorm[#]&,dummy];
Return[(1/normf)*dummy];
];


cohfltM[aa_]:=Module[{ii=1,dummy,spin,mtxa,dim},dim=Dimensions[aa,1][[1]];
If[(dim>nspins)||(dim<1),Message[mrep::"wrong index",cohfltM[aa]],dummy=1;
While[ii<=dim,spin=spinsys[[ii]];
mtxa=cohfltSingleSpin[spin,aa[[ii]]];
dummy=crossProd[dummy,mtxa];
ii++;
];
];
Return[dummy];
];
filterCoherence[aa_,expr_]:=spinTDecomposition[cohfltM[aa]*mrep[expr]];


MakeV[i_,l1_,q1_]:=Module[{dummy},dummy=Apply[spinT,Table[{0,0},{ii,nspins}]];
Part[dummy,i,2]=q1;
Part[dummy,i,1]=l1;
Return[dummy]];
MakeV[i_,x1_]:=
Module[{dummy},dummy=Apply[spinC,Table[e,{ii,nspins}]];
Part[dummy,i]=x1;
Return[dummy]];
MakeVbilin[i_,j_,l1_,q1_,l2_,q2_]:=Module[{dummy},dummy=Apply[spinT,Table[{0,0},{ii,nspins}]];
Part[dummy,i,2]=q1;
Part[dummy,j,2]=q2;
Part[dummy,i,1]=l1;
Part[dummy,j,1]=l2;
Return[dummy]];
MakeVbilin[i_,j_,x1_,x2_]:=Module[{dummy},dummy=Apply[spinC,Table[e,{ii,nspins}]];
Part[dummy,i]=x1;
Part[dummy,j]=x2;
Return[dummy]];


makeHDD[i_,j_,m_]:=Module[{i1,j1},
i1=i;j1=j;
If[i>j,
i1=j;j1=i,Null,Null];
Return[(-1)^m wD[{i1,j1},m]  Sum[Sqrt[3/2]ClebschGordan[{1,m-m1},{1,m1},{2,m}](ispinT[i1,1,m-m1].ispinT[j1,1,m1]+ispinT[i1,1,m1].ispinT[j1,1,m-m1]),{m1,Max[-1,m-1],Min[1,m+1]}]];
];
makeHDD[i_,j_]:=Sum[makeHDD[i,j,m],{m,-2,2}];


makeHJ[i_,j_]:=Module[{i1,j1},
i1=i;j1=j;
If[i>j,
i1=j;j1=i,Null,Null];
Return[
2\[Pi] J[i1,j1] (ispinC[i1,z].ispinC[j1,z]+ispinC[i1,x].ispinC[j1,x]+ispinC[i1,y].ispinC[j1,y])];
];


makeHCSiso[i_]:=wiso[i] ispinC[i,z];
makeHCSA[i_]:=wcsa[i,0] ispinC[i,z]+Sqrt[3/8]wcsa[i,-1] ispinC[i,p]-Sqrt[3/8]wcsa[i,1] ispinC[i,m];


makeHQ[i_]:=Sum[
(-1)^m wQ[i,m]ispinT[i,2,m],{m,-2,2}];


MakeDDHamiltonian[i_,j_]:=
Table[2 (ClebschGordan[{1,q1},{1,q2},{2,q1+q2}]/ClebschGordan[{1,0},{1,0},{2,0}])MakeVbilin[i,j,1,q1,1,q2],{q1,-1,1},{q2,-1,1}]//Flatten;

(* old normalization does not take into acct. the fact that it's a pseudo-2nd rank tensor MakeCSHamiltonian[i_]:=Table[MakeV[i,1,q],{q,-1,1}];*)
(* old MakeCSHamiltonian[i_]:={2Sqrt[3/4]MakeV[i,1,1],2MakeV[i,1,0],2Sqrt[3/4]MakeV[i,1,-1]}
*)
MakeCSHamiltonian[i_]:={Sqrt[3/4]MakeV[i,1,1],MakeV[i,1,0],Sqrt[3/4]MakeV[i,1,-1]};

MakeCSantiHamiltonian[i_]:={(1/Sqrt[2])MakeV[i,1,1],-(1/Sqrt[2])MakeV[i,1,-1]};


MakeDDHamiltonian[i_,j_,m_]:=Sum[2 (ClebschGordan[{1,q1},{1,m-q1},{2,m}]/ClebschGordan[{1,0},{1,0},{2,0}])MakeVbilin[i,j,1,q1,1,m-q1],{q1,-1,1}];


expandDot[expr_]:=Simplify[expr//.
{Dot[p1___,a_*q_,p2___]:>a*Dot[p1,q,p2]/;NumericQ[a],
Dot[p1___,a_,p2___]:>a*Dot[p1,p2]/;NumericQ[a],
Dot[p1___,a_+q_,p2___]:>Dot[p1,a,p2]+Dot[p1,q,p2]
}
];

(* consider rewriting orderDot acc. to sC.sT/. {Dot[p1:sC|sT,p2:sC|sT]\[Rule]p2[2].p1[1]} *)
orderDot[expr_]:=Simplify[expr//.{Dot[p1___,ispinC[i1_,xx1__],ispinC[i2_,xx2__],p2___]:>
Dot[p1,ispinC[i2,xx2],ispinC[i1,xx1],p2]/;i2<i1,
Dot[p1___,ispinC[i1_,xx1__],ispinT[i2_,xx2__],p2___]:>Dot[p1,ispinT[i2,xx2],ispinC[i1,xx1],p2]/;i2<i1,
Dot[p1___,ispinT[i1_,xx1__],ispinC[i2_,xx2__],p2___]:>Dot[p1,ispinC[i2,xx2],ispinT[i1,xx1],p2]/;i2<i1,
Dot[p1___,ispinT[i1_,xx1__],ispinT[i2_,xx2__],p2___]:>Dot[p1,ispinT[i2,xx2],ispinT[i1,xx1],p2]/;i2<i1}
];



safepower[a_,b_]:=
If[b==0,1,a^b,a^b];


gendER[j_,m1_,m_,s_,b_,n1_,n2_,n3_]:=Evaluate[safepower[Cos[b/2]-I n3 Sin[b/2],(j+m-s)]*
safepower[-I n1 Sin[b/2]-n2 Sin[b/2],(m1-m+s)]* safepower[-I n1 Sin[b/2]+n2 Sin[b/2],s]* 
safepower[Cos[b/2]+I n3 Sin[b/2],(j-m1-s)]]/((j+m-s)!(m1-m+s)!s!(j-m1-s)!);

dER[j_,m1_,m_,b_,n1_,n2_,n3_]:=
Simplify[Sqrt[(j+m)! (j-m)! (j+m1)! (j-m1)!] Sum[If[(j-k+m)<0||(j-k-m1)<0||(k-m+m1)<0,0,gendER[j,m1,m,k,b,n1,n2,n3]],{k,0,2j}]];
(* reducedD[j_,m1_,m_,b_]:=dER[j,m1,m,b,0,1,0]; *)

(* problems with b=Pi and b=0 with next one *)
(* reducedD[j_,m1_,m_,b_]:=
If[b===0,
If[m1\[Equal]m,1,0],
Sqrt[(j+m)!(j-m)!/((j+m1)!(j-m1)!)]*
safepower[Sin[b/2],(m-m1)]*
safepower[ Cos[b/2],(m1+m)]*
(JacobiP[j-m,m-m1,m+m1,x]/.x:>Cos[b]),
ERROR
];
*)
reducedD[j_,m1_,m_,b_]:=
Sqrt[(j+m1)!(j-m1)!(j+m)!(j-m)!]*
Sum[
If[(j-s+m)<0||(j-s-m1)<0||(s-m+m1)<0,0,
(-1)^(m1-m+s)
safepower[Cos[b/2],2j+m-m1-2s]
safepower[Sin[b/2],m1-m+2s]/
((j+m-s)!s!(m1-m+s)!(j-m1-s)!)],
{s,0,2j}];

wignerD[j_,m1_,m_,a_,b_,g_]:=
Simplify[Exp[-I m1 a-I m g]reducedD[j,m1,m,b]];
wignerRotMtx[j_,a_,b_,g_]:=
Table[wignerD[j,m1,m,a,b,g],{m1,-j,j},{m,-j,j}];
spinRotMtx[i_,a_,b_,g_]:=Module[{ii=1,dummy,spin,mtxa},
dummy=1;
While[ii<=nspins,
spin=spinsys[[ii]];
If[ii==i,
dummy=crossProd[dummy,wignerRotMtx[spin,a,b,g]],
dummy=crossProd[dummy,IdentityMatrix[2spin+1]] ];
ii++];
Return[dummy];
];


pulse[expr_,i_,a_,phi_,psi_]:=
Module[{dummy,rotmtx},
rotmtx=ComplexExpand[MatrixExp[
-I*a*Cos[psi]*(mrep[ispinC[i,x]]*Cos[phi]+mrep[ispinC[i,y]]*Sin[phi])
-I*Sin[psi]*mrep[ispinC[i,z]]]];
(*Print[rotmtx];*)
Return[rotmtx.expr.dagger[rotmtx]];
];


evolve[expr_,H_,t_]:=
Module[{dummy},dummy=ComplexExpand[MatrixExp[-N[I*H*t]]];
Return[dummy.expr.dagger[dummy]];
];
acquire[expr_,H_,t_,obs_,npt_]:=
Module[{dummy,expr2,i},dummy=ComplexExpand[MatrixExp[-N[I*H*t]]];
fid=Table[0,{npt}];
expr2=expr;
For[i=1,i<=npt,i++,
fid[[i]]=Tr[dagger[obs].expr2];
expr2=dummy.expr2.dagger[dummy];
];
Return[fid];
];


getspec[sigma_,H_,det_,npt_,frange_]:=
Module[{dummy,dim=Length[H],d,v,detHB,sigmaHB,df=frange[[2]]-frange[[1]],spec,pos,A,B},
spec=Table[0,{npt}];
(* calc. d, normalized eigenvecs *)
{d,v}=Eigensystem[N[H]/(2Pi)];
(*Print[d];
Print[v];*)
 v1=1/Sqrt[
Map[
Apply[Plus,#^2]&,v
]];
v=DiagonalMatrix[v1].v;

detHB=v.det.dagger[v];
sigmaHB=v.sigma.dagger[v];
(*Print[detHB];
Print[sigmaHB];*)
For[i=1,i<=dim,i++,
For[j=1,j<=dim,j++,
A=detHB[[i,j]]*sigmaHB[[j,i]];
B=d[[j]]-d[[i]];
pos=Round[N[(Re[B]-frange[[1]])npt/df]];
(* Print[pos," ",i," ",j," ",A," ",B]; *)
(*Print [Abs[A]>10^(-8)," ",pos, " ",(Abs[A]>10^(-8))&&(pos\[GreaterEqual]1)&&(pos\[LessEqual]npt)];*)
If[(Abs[A]>10^(-8)) &&(pos>=1) && (pos<=npt) ,
(*Print[pos," ",i," ",j," ",A," ",B];*)
spec[[pos]]=spec[[pos]]+A;
];
]
];
Return[{Range[frange[[1]],frange[[2]],N[df/(npt-1)]],spec}];
]




plotspec[spec_]:=ListPlot[Re[spec],PlotRange->All,Joined->True,Frame->{True,False,False,False},Axes->False]
plotspec[scale_,spec_]:=ListPlot[Transpose[{scale,Re[spec]}],PlotRange->All,Joined->True,Frame->{True,False,False,False},Axes->False]
plotspecY[scale_,spec_]:=ListPlot[Transpose[{scale,Re[spec]}],PlotRange->All,Joined->True,Frame->{True,False,False,False},Axes->False]
plotspecIm[spec_]:=ListPlot[Im[spec],PlotRange->All,Joined->True,Frame->{True,False,False,False},Axes->False]
speclb[spec_,lb_]:=Module[{fid,out,rg,npt},npt=Length[spec];fid=InverseFourier[ftshift[spec]];fid=fid Exp[N[-(((Range[Length[fid]]-1) lb)/Length[fid])]];out=ftshift[Fourier[fid]];Return[out];];


rotateSpatial[w_,i_,a_,b_,g_]:=
Module[{dummy,tmpt},
For[m1=-2,m1<=2,m1++,
tmpt[i,m1]=
Sum[w[i,m] wignerD[2,m,m1,a,b,g],{m,-2,2}]
];
copyTensor[tmpt,w];
];



makeSpatialD[wd_,i_,j_,wD_,a_,b_,g_]:=Module[{dummy},
dummy=Simplify[wignerRotMtx[2,a,b,g].
{{0},{0},{wD},{0},{0}}];
For[ii=1,ii<=Length[dummy],ii++,
wd[{i,j},ii-3]=dummy[[ii,1]];
wd[{j,i},ii-3]=dummy[[ii,1]];
];
Return[dummy];
];
makeSpatialCSA[wcsa_,i_,delta_,eta_,a_,b_,g_]:=Module[{dummy},dummy=Simplify[wignerRotMtx[2,a,b,g].{{delta eta/Sqrt[6]},{0},{delta},{0},{delta eta/Sqrt[6]}}];
For[ii=1,ii<=Length[dummy],ii++,wcsa[i,ii-3]=dummy[[ii]][[1]];];
Return[dummy];];
makeSpatialQ[wq_,i_,delta_,eta_,a_,b_,g_]:=Module[{dummy},dummy=Simplify[wignerRotMtx[2,a,b,g].{{delta eta/2},{0},{delta Sqrt[3/2]},{0},{delta eta/2}}];
For[ii=1,ii<=Length[dummy],ii++,wq[i,ii-3]=dummy[[ii]][[1]];];
Return[dummy];];



MakeQHamiltonian[i_]:=Table[MakeV[i,2,q],{q,-2,2}];


MakeAllHamiltonians[Hlist_]:=Module[{dummy={},tmp,listidx=1},
HamTypes={};

While[listidx<Length[Hlist],

Which[

Hlist[[listidx]]=="DD",

tmp=MakeDDHamiltonian[Hlist[[listidx+1]],Hlist[[listidx+2]]];
Map[AppendTo[dummy,#]&,tmp];
For[i=1,i<=Length[tmp],i++,AppendTo[HamTypes,Hlist[[{listidx,listidx+1,listidx+2}]]
]];
Print["Added dipole-dipole"];
(*Print[dummy]*);
listidx=listidx+3,

(*--------------------------------*)
Hlist[[listidx]]=="CS",

tmp=MakeCSHamiltonian[Hlist[[listidx+1]] ];
Map[AppendTo[dummy,#]&,tmp];
For[i=1,i<=Length[tmp],i++,AppendTo[HamTypes,Hlist[[{listidx,listidx+1}]]]];
Print["Added CSA"];
listidx=listidx+2,

(*--------------------------------*)
(*---CS antisymmetric --*)
Hlist[[listidx]]=="CSanti",

tmp=MakeCSantiHamiltonian[Hlist[[listidx+1]] ];
Map[AppendTo[dummy,#]&,tmp];
For[i=1,i<=Length[tmp],i++,AppendTo[HamTypes,Hlist[[{listidx,listidx+1}]]]];
Print["Added antisymmetric CSA"];
listidx=listidx+2,

(*--------------------------------*)
Hlist[[listidx]]=="Q",tmp=MakeQHamiltonian[Hlist[[listidx+1]]];
              Map[AppendTo[dummy,#]&,tmp];
              For[i=1,i<=Length[tmp],i++
AppendTo[HamTypes,Hlist[[{listidx,listidx+1}]]]];
              Print["Added Q"];
             listidx=listidx+2,(*-----DEFAULT---------------------------*)
(*-----DEFAULT---------------------------*)
True,
Print["Hamiltonian not found"];
listidx=listidx+1;
Abort[];
];
];
Return[Flatten[dummy]];
];


frequ[a_ spinT[l__]]:=frequ[spinT[l]];
frequ[spinT[l__]/a_]:=frequ[spinT[l]];
frequ[spinT[l__]]:=Sum[List[l][[i]][[2]] frequencies[[i]],{i,1,Dimensions[List[l]][[1]]}];



cohord[a_ spinT[l__]]:=cohord[spinT[l]];
cohord[spinT[l__]/a_]:=cohord[spinT[l]];
cohord[spinT[l__]]:=Sum[List[l][[i]][[2]],{i,1,Dimensions[List[l]][[1]]}];



mrep::"unknown operator"="Unknown operator description used in `1`.";
mrep::"wrong index"="Operator index used in `1` is not compatible with spin system."; 
mrep[spinT[a__]]:=Module[{ii=1,dummy,spin,mtxa,dim},
dim=Dimensions[{a},1][[1]];
If[(dim>nspins)||(dim<1),
Message[mrep::"wrong index",spinT[a]];
dummy=spinT[a],
dummy=1;
While[ii<=dim,
spin=spinsys[[ii]];
If[(List[a][[ii]][[1]]==0) &&(List[a][[ii]][[2]]==0),
mtxa=IdentityMatrix[2spin+1],
mtxa=sphtens[
List[a][[ii]][[1]],List[a][[ii]][[2]],spin,"b"];
];
dummy=crossProd[dummy,mtxa];
ii++];
];
Return[dummy];
];

mrep[spinC[a__]]:=Module[{ii,dummy,spin,dim},ii=1;dummy=1;
dim=Dimensions[{a},1][[1]];
If[(dim>nspins)||(dim<1),
Message[mrep::"wrong index",spinC[a]];
dummy=spinC[a],
While[ii<=dim,spin=spinsys[[ii]];
dummy=crossProd[dummy,
Which[
List[a][[ii]]===e,IdentityMatrix[2spin+1],List[a][[ii]]===x,IxOp[spin],
List[a][[ii]]===y,IyOp[spin],
List[a][[ii]]===z,IzOp[spin],
List[a][[ii]]===p,IpOp[spin],
List[a][[ii]]===m,ImOp[spin],
True,Message[mrep::"unknown operator", spinC[a] ] 
]];
ii++];
];
Return[dummy];
];

mtxST[spin_,m1_,m_]:=Module[{dummy},
dummy=0*IdentityMatrix[2spin+1];
dummy[[-m+spin+1,-m1+spin+1]]=1;
Return[dummy];
];

mrep[ispinST[i_,m1_,m_]]:=Module[{dummy=1,ii,spin},
If[i<=nspins&&i>=1,
For[ii=1,ii<i,ii++,
spin=spinsys[[ii]];
dummy=crossProd[dummy,IdentityMatrix[2spin+1]];
];
spin=spinsys[[i]];
dummy=crossProd[dummy,mtxST[spin,m1,m]];
For[ii=i+1,ii<=nspins,ii++,
spin=spinsys[[ii]];
dummy=crossProd[dummy,IdentityMatrix[2spin+1]];
];
Return[dummy],
Message[mrep::"wrong index",ispinST[i,m1,m]];
];
];


mrep[(p11:ispinC | ispinT)[a__]]:=If[{a}[[1]]<= nspins && {a}[[1]]>=1,mrep[MakeV[Sequence[a]]],
Message[mrep::"wrong index",p11[a]];
p11[a]
];
(*mrep[ispinT[a__]]:=mrep[MakeV[Sequence[a]]];*)
mrep[a_]:=a/.{spinT[aa__]:>mrep[spinT[aa]],
spinC[bb__]:>mrep[spinC[bb]],ispinT[aa__]:> mrep[ispinT[aa]], ispinC[aa__]:> mrep[ispinC[aa]],
ispinST[aa__]:> mrep[ispinST[aa]]};

mrep[unitE]:=unitEMTX;
mrep[zero]:=zeroMTX;


convertTtoPM[a_]:=(a/.
{
ispinT[i_,1,1]:> -2^(-1/2)ispinC[i,p],ispinT[i_,1,-1]:> 2^(-1/2)ispinC[i,m],
ispinT[i_,1,0]:> ispinC[i,z]
})//expandDot;
toispin[a_]:=a/.{spinC[aa__]:> toispin[spinC[aa]],spinT[aa__]:> toispin[spinT[aa]]};
toispin[spinC[aa__]]:=Module[{dummy=1,ii=1},
While[ii<=Dimensions[List[aa],1][[1]],
If[List[aa][[ii]]=!=e,
If[dummy===1,dummy=ispinC[ii,List[aa][[ii]] ],
dummy=dummy.ispinC[ii,List[aa][[ii]] ] ] ];
ii++];
If[dummy===1,Return[unitE],
Return[orderDot[dummy]]];];

toispin[spinT[aa__]]:=Module[{dummy=1,ii=1,L,M,add},
While[ii<=Dimensions[List[aa],1][[1]],
L=List[aa][[ii]][[1]];
M=List[aa][[ii]][[2]];If[Not[L===0 && M===0],
If[dummy===1,
dummy=ispinT[ii,L,M],dummy=dummy.ispinT[ii,L,M];
];
];
ii++];
If[dummy===1,Return[unitE],
 Return[orderDot[dummy]]];
];


spinTDecomposition[a_]:=Module[{dummy},
If[!ValueQ[basisMTX],
basis=MakeBasis;
basisMTX=mrep[basis];
];
dummy=Map[Transpose[Conjugate[#]].a&,basisMTX];
dummy=Map[Tr[#]&,dummy];
Return[toispin[Simplify[Apply[Plus,dummy*basis]]]]];


spinCDecomposition[a_]:=Module[{dummy},
If[!ValueQ[basisMTXCart],
basisCart=MakeCartesianBasis;
basisMTXCart=mrep[basisCart];
];
dummy=Map[Transpose[Conjugate[#]].a&,basisMTXCart];
dummy=Map[Tr[#]&,dummy];
Return[toispin[Simplify[Apply[Plus,dummy*basisCart]]]]];


spinTCommutator[a_,b_]:=spinTDecomposition[commutator[mrep[a],mrep[b]]];


spinCCommutator[a_,b_]:=spinCDecomposition[commutator[mrep[a],mrep[b]]];


makePositFrequ[a_]:=Module[{dummy,factor},dummy=a;factor=1;
If[Head[a]==Plus,dummy=First[a]];
If[Head[dummy]==Times,If[First[dummy]<0,factor=-1]];
Return[factor*a];];


projectionOp[l_List,b_]:=Module[{dummy2},If[savedprojop===lll,Null,projop=mrep[l];
projop=Map[(1/Tr[Transpose[Conjugate[#]].#])*#&,projop];
projopconj=Map[Transpose[Conjugate[#]]&,projop];
savedprojop=l;];
dummy=Map[Simplify[Tr[#.b]]&,projopconj]*projop;
Return[Simplify[Apply[Plus,dummy]]];];
oneMinusProjectionOp[l_List,b_]:=Simplify[b-projectionOp[l,b]];


RedfieldCoeff[op1_,op2_]:=Module[{dummy,nham=Length[HamSpinTList],didx1,didx2,ord},
dummy=(1/2)Sum[
If[HamFrequSign[[r]]===HamFrequSign[[r1]],
(* make sdfJ symmetrical in the interactions *)
ord=Sort[{r,r1}];
didx2=ord[[2]];
didx1=ord[[1]];
sdfJ[HamTypes[[didx1]],HamTypes[[didx2]],HamFrequ[[r1]]]*Simplify[Tr[Transpose[ComplexExpand[Conjugate[commutator[HamMList[[r]],mrep[op1]]]]].commutator[HamMList[[r1]],mrep[op2]]]
],0],
{r,1,nham},{r1,1,nham}];
dummy=dummy/calcnormSQR[op1];
Return[Simplify[dummy]];
];


Format[ispinC[i_,xx_]]:=Subscript["I",SequenceForm[i,Which[xx===p,"+",xx===m,"-",True,xx]]];
Format[ispinT[i_,L_,M_]]:=DisplayForm[SubsuperscriptBox["T",SequenceForm[L,",",M],SequenceForm["(",i,")"]]];
Format[wD[{i_,j_},m_]]:=DisplayForm[SubsuperscriptBox["\[Omega]",SequenceForm["D",m],SequenceForm["(",i,",",j,")"]]];
Format[wD[{i_,j_}]]:=DisplayForm[SubsuperscriptBox["\[Omega]","D",SequenceForm["(",i,",",j,")"]]];
Format[wiso[i_]]:=DisplayForm[SubsuperscriptBox["\[Omega]","iso",SequenceForm["(",i,")"]]];
Format[wcsa[i_,m_]]:=DisplayForm[SubsuperscriptBox["\[Omega]",SequenceForm["csa",m],SequenceForm["(",i,")"]]];
Format[wQ[i_,m_]]:=DisplayForm[SubsuperscriptBox["\[Omega]",SequenceForm["Q",m],SequenceForm["(",i,")"]]];
Format[J[i_,j_]]:=Superscript["J",SequenceForm["(",i,",",j,")"]];
Format[unitE]:="Id";
Format[sdfJ[a_,b_,c_]]:=SequenceForm[DisplayForm[SubsuperscriptBox["J",a,b]],"(",c,")"];





End[];
EndPackage[];
