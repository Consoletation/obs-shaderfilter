// Anime4K shader
// with help from StealthCT
// https://github.com/Anime4K/Anime4K
uniform string notes = "Step3";

float4 mainImage(VertData v_in) : TARGET
{
        // dimensions
        float dx = v_in.uv.x;
        float dy = v_in.uv.y;

        float4 c0 = image.Sample(textureSampler, v_in.uv); // Current Color

        //[tl  t tr]
        //[ l     r]
        //[bl  b br]
        float t = image.Sample(textureSampler, v_in.uv + float2(0, -dy))[3];
        float tl = image.Sample(textureSampler, v_in.uv + float2(-dx, -dy))[3];
        float tr = image.Sample(textureSampler, v_in.uv + float2(dx, -dy))[3];

        float l = image.Sample(textureSampler, v_in.uv + float2(-dx, 0))[3];
        float r = image.Sample(textureSampler, v_in.uv + float2(dx, 0))[3];

        float b = image.Sample(textureSampler, v_in.uv + float2(0, dy))[3];
        float bl = image.Sample(textureSampler, v_in.uv + float2(-dx, dy))[3];
        float br = image.Sample(textureSampler, v_in.uv + float2(dx, dy))[3];

        //Horizontal Gradient
        //[-1  0  1]
        //[-2  0  2]
        //[-1  0  1]
        float xgrad = (-tl + tr - l - l + r + r - bl + br);

        //Vertical Gradient
        //[-1 -2 -1]
        //[ 0  0  0]
        //[ 1  2  1]
        float ygrad = (-tl - t - t - tr + bl + b + b + br);

        //Computes the luminance's gradient and saves it in the unused alpha channel
        return float4(c0[0], c0[1], c0[2], 1 - clamp(sqrt(xgrad * xgrad + ygrad * ygrad), 0, 1));
}
