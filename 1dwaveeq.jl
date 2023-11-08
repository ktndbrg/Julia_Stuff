using Plots

# Constant's (parameters) to be used in our example
L = 20			    # Length of the rope
N = 200				# Number of points
h = float(L / N)	# Our position increment
s = 0.9			    # h² / k², but example has this set to 0.9
k = h * √(s)	    # Our time increment

# Also known as initial condition
function ϕ(x)
	# Parameters, can be changed
	a = 1.0
	b = 0.5
	x² = (x - 0.5*L) ^ 2

	# The mathematical equation for ϕ(x)
	# See the pdf PartialDifferentialEquations
	return a * exp(-b * (x²))
end

# Also known as initial condition for the derivative
function ψ(x)
	# Example uses constant function 0.0
	return 0.0
end

# Exact solution, just to verify our numerical one
function exact(x, t)
	return 0.5 * (ϕ(x + t) + ϕ(x - t))
end

#--- START OF MAIN PROGRAM! ---#
# let the fun begin!
# make a list of x-values, this is our position on the string/wave
position = [h * i for i ∈ range(0, stop=N, length=N)]

# u(x, t) is the amplitude of the wave
# make a list of all the values for this amplitude
# Zero all values, just initialize the matrix
amplitude = [0.0 for row ∈ 1:N, column ∈ 1:N]

# Initial condition for amplitude at time = 0.0, see PDF example, p.32
amplitude[1, :] = [ϕ(x) for x ∈ position]

# Initial condition for time n = 1
#amplitude[2, :] = [0.5 * s * (ϕ(position[i+1]) + ϕ(position[i-1])) + (1 - s) * ϕ(position[i]) + k * ψ(position[i]) for i ∈ 2:N-1]
for i ∈ 2:N-1
	xₙ₊₁	= position[i+1] 	# next position
	xₙ		= position[i]		# current position
	xₙ₋₁	= position[i-1]		# previous position
	amplitude[2, i] = 0.5 * s * (ϕ(xₙ₊₁) + ϕ(xₙ₋₁)) + (1 - s) * ϕ(xₙ) + k * ψ(xₙ)
end
# We needed to find both of these before we could start the numerical.

## Pause the graph until we press 'Enter'
gui(plot(position, amplitude[1, :], xlims=(0.0, L), ylims=(0.0, 1.0), xlabel="Position", ylabel="Amplitude", title="Numerical solution"))
readline()

# Make all of our values for the graph,
# begin in time = 2
# j is just an index to get our time values, the value starts at 0.0
for n ∈ 2:N-1
	for j ∈ 2:N-1
		amplitude[n+1, j] = s * (amplitude[n, j+1] + amplitude[n, j-1]) + 2 * (1 - s) * amplitude[n, j] - amplitude[n - 1, j]
	end

	# Plot all of our values, and push the time forward
    gui(plot(position, amplitude[n+1, :], xlims=(0.0, L), ylims=(0.0, 1.0), xlabel="Position", ylabel="Amplitude", title="time[$n] Numerical solution"))
	sleep(0.016)
end

# Check the exact solution
for time ∈ 0:N
    gui(plot(position, [exact(x, time * k) for x ∈ position], xlims=(0.0, L), ylims=(0.0, 1.0), xlabel="Position", ylabel="Amplitude", title="Exact"))
    sleep(0.016)
end
