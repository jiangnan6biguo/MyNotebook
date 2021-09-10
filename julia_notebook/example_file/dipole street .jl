using Plots, LaTeXStrings, FourierGPE, OrdinaryDiffEq
gr(titlefontsize=12,size=(500, 300),colorbar=false)


## set the system size, and number of spatial points and initialize default simulation
L = (128., 128.)
N = (512, 512)
sim = Sim(L, N)
@unpack_Sim sim


## simulation parameters μ=15 means gn0=15 
μ = 15.0
γ = 1.0


# choose TF state as the initial state to evalue the ground state.(does it use the imaginary time evolution?)
ψtf(x,y,μ,g) = sqrt(μ / g) * sqrt(max(1.0 - V(x, y, 0.0) / μ, 0.0) + im * 0.0)
healinglength(x,y,μ,g) = 1 / sqrt(g * abs2(ψtf(x, y, μ, g)))

## make initial state
x, y = X
dx = x/N[1]
dy  = y/N[2]
ψi = ψtf.(x, y', μ, g)
ϕi = kspace(ψi, sim)

ti = 0.0
tf = 30pi
Nt = 200
t = LinRange(ti, tf, Nt)

@pack_Sim! sim

## evolve and get the ground state
@time sol = runsim(sim)

# this is the ground state i.e. new initial state.
ψg = xspace(sol[end], sim) 
showpsi(x,y,ψg)
#savefig("ground state2")
# check phase
#angle.(ψg[2])
plot(angle.(ψg[:,end]))
#savefig("phase of ψg2")
angle.(ψg[:,end])
using VortexDistributions


function periodic_Dipole!(psi::F,dip::Array{ScalarVortex{T},1}) where {T <: CoreShape, F<:VortexDistributions.Field}
  @assert length(dip) == 2
  @assert dip[1].vort.qv + dip[2].vort.qv == 0
  #@assert hypot(dip[1].vort.xv-dip[2].vort.xv,dip[1].vort.yv-dip[2].vort.yv) >= 2*pi
  @unpack ψ,x,y = psi
  (dip[1].vort.qv > 0) ? (jp = 1;jn = 2) : (jp = 2;jn = 1)
  vp = vortex_array(dip[jp].vort)[1:2]
  vn = vortex_array(dip[jn].vort)[1:2]
  @. ψ *= abs(dip[jn](x,y')*dip[jp](x,y'))
  ψ .*= exp.(im*dipole_phase(x,y,vp...,vn...))
  @pack! psi = ψ
end


rv = 3
c = -60
d = 2
a = 2*d/0.281
ξ = healinglength(rv,0.,μ,g)
pv1 = PointVortex(c,d,1)
pv2 = PointVortex(c+a/2,-d,-1)
pv3 = PointVortex(c+a,d,1)
pv4 = PointVortex(c+3*a/2,-d,-1)
pv5 = PointVortex(c+2*a,d,1)
pv6 = PointVortex(c+5*a/2,-d,-1)
pv7 = PointVortex(c+3*a,d,1)
pv8 = PointVortex(c+7*a/2,-d,-1)
pv9 = PointVortex(c+4*a,d,1)
pv10 = PointVortex(c+9*a/2,-d,-1)
pv11 = PointVortex(c+5*a,d,1)
pv12 = PointVortex(c+11*a/2,-d,-1)
pv13 = PointVortex(c+6*a,d,1)
pv14 = PointVortex(c+13*a/2,-d,-1)
pv15 = PointVortex(c+7*a,d,1)
pv16 = PointVortex(c+15*a/2,-d,-1)
pv17 = PointVortex(c+8*a,d,1)
pv18 = PointVortex(c+17*a/2,-d,-1)


vi1 = ScalarVortex(ξ,[pv1,pv2])
vi2 = ScalarVortex(ξ,[pv3,pv4])
vi3 = ScalarVortex(ξ,[pv5,pv6])
vi4 = ScalarVortex(ξ,[pv7,pv8])
vi5 = ScalarVortex(ξ,[pv9,pv10])
vi6 = ScalarVortex(ξ,[pv11,pv12])
vi7 = ScalarVortex(ξ,[pv13,pv14])
vi8 = ScalarVortex(ξ,[pv15,pv16])
vi9 = ScalarVortex(ξ,[pv17,pv18])

psi = Torus(copy(ψg),x,y)
periodic_Dipole!(psi,vi1)
periodic_Dipole!(psi,vi2)
periodic_Dipole!(psi,vi3)
periodic_Dipole!(psi,vi4)
periodic_Dipole!(psi,vi5)
periodic_Dipole!(psi,vi6)
periodic_Dipole!(psi,vi7)
periodic_Dipole!(psi,vi8)
periodic_Dipole!(psi,vi9)


ψi= psi.ψ
ϕi = kspace(ψi,sim)
showpsi(x,y,psi.ψ)
#savefig("dipolestreetwithoutevolving1")
plot(angle.(ψi[:,end]))

grad_x = zeros(ComplexF64,512,512)
grad_y = zeros(ComplexF64,512,512)
grad_xc = zeros(ComplexF64,512,512)
grad_yc = zeros(ComplexF64,512,512)
j_x = zeros(ComplexF64,512,512)
j_y = zeros(ComplexF64,512,512)

for i in range(1,stop=511)
  for j in range(1,stop=511)
    grad_x[i,j] = (ψi[i+1,j]-ψi[i,j])/(dx[i+1]-dx[i])
    grad_y[i,j] = (ψi[i,j+1]-ψi[i,j])/(dy[i+1]-dy[i])
    grad_xc[i,j] = (conj(ψi[i+1,j])-conj(ψi[i,j]))/(dx[i+1]-dx[i])
    grad_yc[i,j] = (conj(ψi[i,j+1])-conj(ψi[i,j]))/(dy[i+1]-dy[i])
    j_x[i,j] = (conj(ψi[i,j]).*grad_x[i,j]-ψi[i,j].*grad_xc[i,j])
    j_y[i,j] = (conj(ψi[i,j]).*grad_y[i,j]-ψi[i,j].*grad_yc[i,j])
  end
end
imag.(j_x+j_y)
using PyPlot
PyPlot.clf()
PyPlot.pcolormesh(imag.(j_x))
PyPlot.colorbar()
PyPlot.savefig("C:\\Users\\MarvinBai\\Desktop\\superfluid turbulence\\Yixiu-Bradley shared\\fig_testx")

PyPlot.clf()
PyPlot.pcolormesh(real.(j_y))
PyPlot.colorbar()
PyPlot.savefig("C:\\Users\\MarvinBai\\Desktop\\superfluid turbulence\\Yixiu-Bradley shared\\fig_testy")

PyPlot.clf()
PyPlot.streamplot(x,y,imag.(j_x),imag.(j_y),density=[5,5])
PyPlot.savefig("C:\\Users\\MarvinBai\\Desktop\\superfluid turbulence\\Yixiu-Bradley shared\\fig_testyyy")


PyPlot.clf()
q = PyPlot.quiver(x,y,abs.(j_x)./10000,abs.(j_y)./10000)
PyPlot.quiverkey(q, X=30, Y=30, U=0.01,label="test")
PyPlot.savefig("C:\\Users\\MarvinBai\\Desktop\\superfluid turbulence\\Yixiu-Bradley shared\\fig_testYy")

angle(1+im*1)

us
a1 = PyPlot.streamplot(y,x,real.(j_y),real.(j_x))
PyPlot.show(a1)
PyPlot.savefig("C:\\Users\\MarvinBai\\Desktop\\superfluid turbulence\\Yixiu-Bradley shared")
a1 = PyPlot.plot(real.(j_x))
show(a1)
γ = 0.0
ti = 0.0
tf = 60pi
Nt = 100
t = LinRange(ti, tf, Nt)

reltol = 1e-7
alg = OrdinaryDiffEq.DP5()
@pack_Sim! sim

@time solv = runsim(sim)
ϕf = solv[end]
ψf = xspace(ϕf, sim)
showpsi(x,y,ψf)
#savefig("dipoleevolving")
grad_x1 = zeros(ComplexF64,512,512)
grad_y1 = zeros(ComplexF64,512,512)
grad_xc1 = zeros(ComplexF64,512,512)
grad_yc1 = zeros(ComplexF64,512,512)
j_x1 = zeros(ComplexF64,512,512)
j_y1 = zeros(ComplexF64,512,512)

for i in range(1,stop=511)
  for j in range(1,stop=511)
    grad_x1[i,j] = (ψf[i+1,j]-ψf[i,j])/(dx[i+1]-dx[i])
    grad_y1[i,j] = (ψf[i,j+1]-ψf[i,j])/(dy[i+1]-dy[i])
    grad_xc1[i,j] = (conj(ψf[i+1,j])-conj(ψf[i,j]))/(dx[i+1]-dx[i])
    grad_yc1[i,j] = (conj(ψf[i,j+1])-conj(ψf[i,j]))/(dy[i+1]-dy[i])
    j_x1[i,j] = (conj(ψf[i,j]).*grad_x1[i,j]-ψf[i,j].*grad_xc1[i,j])
    j_y1[i,j] = (conj(ψf[i,j]).*grad_y1[i,j]-ψf[i,j].*grad_yc1[i,j])
  end
end

PyPlot.clf()
PyPlot.streamplot(x,y,imag.(j_x1),imag.(j_y1),density=[5,5])
PyPlot.savefig("C:\\Users\\MarvinBai\\Desktop\\superfluid turbulence\\Yixiu-Bradley shared\\fig_test111")







#calculate the flow field by using the functions of gradient and current.
k2field = k2(K)-k2(K)   #where I do not know why should we create the kinetic energy, so I set it to be 0.

psi = XField(angle.(ψi) |> complex,X,K,k2field)
function gradient(psi::XField{2})
	@unpack psiX,K = psi; kx,ky = K; ψ = psiX
	ϕ = fft(ψ)
	ψx = ifft(im*kx.*ϕ)
	ψy = ifft(im*ky'.*ϕ)
	return ψx,ψy
end
gradient(psi)

function current(psi::XField{2})
	@unpack psiX,K = psi; kx,ky = K; ψf = psiX
    ψx,ψy = gradient(psi)
	jx = @. imag(conj(ψf)*ψx)
	jy = @. imag(conj(ψf)*ψy)
	return jx,jy
end

current(psi)
plot(x,current(psi)[1])


anim = @animate for i in eachindex(t)
    psi = XField(angle.(xspace(solv[i], sim)) |> complex,X,K,k2field)
    plot(x,current(psi)[2])
    #showpsi(x, y, psi)
end

saveto = joinpath(@__DIR__, "dipole-streetnew3.gif")
gif(anim,saveto,fps=25)   
ψi[512,512]
