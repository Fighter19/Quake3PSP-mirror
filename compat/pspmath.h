// This file is a partial reimplementation of the pspmath library by mrmrice
// It provides access to common math functions using the vector floating point unit (VFPU)
// of the PSP, which provides faster calculation than the standard math library.
#pragma once
#include <math.h>

// Define F_PI. Cast is required to avoid generation of double constant
#ifdef M_PI
#define F_PI (float)M_PI
#else
// Definition for IntelliSense
#define F_PI (float)3.14159265358979323846
#endif

#ifdef M_PI_2
#define F_PI_2 (float)M_PI_2
#else
#define F_PI_2 (float)1.57079632679489661923
#endif

static float vfpu_cosf(float value)
{
	float result = 0.5f;
	float temp = value / F_PI_2;
	__asm__ volatile (
		// Load value into vector at 0
		"lv.s s000, 0(%[x])\n"
		// Actually do cosf
		"vcos.s s000, s000\n"
		// Store result
		"sv.s s000, 0(%[res])\n"
		:
		: [x]"r" (&temp), [res]"r" (&result)
		: "memory"
	);
	return result;
}

static float vfpu_sinf(float value)
{
	float result = 0.5f;
	float temp = value / F_PI_2;
	__asm__ volatile (
		// Load value into vector at 0
		"lv.s s000, 0(%[x])\n"
		// Actually do sinf
		"vsin.s s000, s000\n"
		// Store result
		"sv.s s000, 0(%[res])\n"
		:
		: [x]"r" (&temp), [res]"r" (&result)
		: "memory"
	);
	return result;
}

static float vfpu_fabsf(float value)
{
	return fabsf(value);
}

static float vfpu_sqrtf(float value)
{
	float result = 0.5f;
	__asm__ volatile (
		// Load value into vector at 0
		"lv.s s000, 0(%[x])\n"
		// Actually do sinf
		"vsqrt.s s000, s000\n"
		// Store result
		"sv.s s000, 0(%[res])\n"
		:
		: [x]"r" (&value), [res]"r" (&result)
		: "memory"
	);
	return result;
}

static float vfpu_tanf(float value)
{
	// tan(x) = sin(x) / cos(x)
	float result = 0.5f;
	float temp = value / F_PI_2;
	__asm__ volatile (
		// Load value into vector at 0
		"lv.s s000, 0(%[x])\n"
		// Actually do sinf
		"vsin.s s001, s000\n"
		// Actually do cosf
		"vcos.s s000, s000\n"
		// Divide sin by cos
		"vdiv.s s000, s001, s000\n"
		// Store result
		"sv.s s000, 0(%[res])\n"
		:
		: [x]"r" (&temp), [res]"r" (&result)
		: "memory"
	);
	return result;
}

static float _internal_asinf(float value)
{
	float result = 0.5f;
	__asm__ volatile (
		// Load value into vector at 0
		"lv.s s000, 0(%[x])\n"
		// Actually do asinf
		"vasin.s s000, s000\n"
		// Store result
		"sv.s s000, 0(%[res])\n"
		:
		: [x]"r" (&value), [res]"r" (&result)
		: "memory"
	);

	return result;
}

static float vfpu_atanf(float value)
{
	// Catch special cases first, for compatibility with newlib implementation
	if (value == INFINITY)
	{
		return F_PI_2;
	}
	else if (value == -INFINITY)
	{
		return -F_PI_2;
	}

	// Based on following knowledge
	// See: https://math.stackexchange.com/questions/254561/proof-of-arctanx-arcsinx-sqrt1x2
	// atan(x) = asin(x / sqrt(1 + x^2))
	return _internal_asinf(value / vfpu_sqrtf(1.0f + value * value)) * F_PI_2;
}

static float vfpu_atan2f(float y, float x)
{
	if (y == 0)
	{
		return 0.0;
	}

	if (x >= 0 && y >= 0)
	{
		// First quadrant
		return vfpu_atanf(y / x);
	}
	else if (x < 0 && y >= 0)
	{
		// Second quadrant
		return F_PI - vfpu_atanf(y / -x);
	}
	else if (x < 0 && y < 0)
	{
		// Third quadrant
		return -F_PI + vfpu_atanf(y / x);
	}

	// Fourth quadrant
	return -vfpu_atanf(-y / x);
}
