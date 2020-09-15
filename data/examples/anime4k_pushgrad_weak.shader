// Anime4K shader
// with help from StealthCT
// https://github.com/Anime4K/Anime4K
uniform float strength = 0.7;
uniform string notes = "Step4";

float min3(float4 a, float4 b, float4 c)
{
        return min(min(a[3], b[3]), c[3]);
}

float max3(float4 a, float4 b, float4 c)
{
        return max(max(a[3], b[3]), c[3]);
}

float4 getAverage(float4 cc, float4 a, float4 b, float4 c)
{
        return cc * (1 - strength) + ((a + b + c) / 3) * strength;
}

float4 mainImage(VertData v_in) : TARGET
{
        // dimensions
        float dx = v_in.uv.x;
        float dy = v_in.uv.y;

        float4 cc = image.Sample(textureSampler, v_in.uv); // Current Color

        float4 t = image.Sample(textureSampler, v_in.uv + float2(0, -dy));
        float4 tl = image.Sample(textureSampler, v_in.uv + float2(-dx, -dy));
        float4 tr = image.Sample(textureSampler, v_in.uv + float2(dx, -dy));

        float4 l = image.Sample(textureSampler, v_in.uv + float2(-dx, 0));
        float4 r = image.Sample(textureSampler, v_in.uv + float2(dx, 0));

        float4 b = image.Sample(textureSampler, v_in.uv + float2(0, dy));
        float4 bl = image.Sample(textureSampler, v_in.uv + float2(-dx, dy));
        float4 br = image.Sample(textureSampler, v_in.uv + float2(dx, dy));

        float4 lightestColor = cc;

        //Kernel 0 and 4
        float maxDark = max3(br, b, bl);
        float minLight = min3(tl, t, tr);

        if (minLight > cc[3] && minLight > maxDark) {
                return getAverage(cc, tl, t, tr);
        } else {
                maxDark = max3(tl, t, tr);
                minLight = min3(br, b, bl);
                if (minLight > cc[3] && minLight > maxDark) {
                        return getAverage(cc, br, b, bl);
                }
        }

        //Kernel 1 and 5
        maxDark = max3(cc, l, b);
        minLight = min3(r, t, tr);

        if (minLight > maxDark) {
                return getAverage(cc, r, t, tr);
        } else {
                maxDark = max3(cc, r, t);
                minLight = min3(bl, l, b);
                if (minLight > maxDark) {
                        return getAverage(cc, bl, l, b);
                }
        }

        //Kernel 2 and 6
        maxDark = max3(l, tl, bl);
        minLight = min3(r, br, tr);

        if (minLight > cc[3] && minLight > maxDark) {
                return getAverage(cc, r, br, tr);
        } else {
                maxDark = max3(r, br, tr);
                minLight = min3(l, tl, bl);
                if (minLight > cc[3] && minLight > maxDark) {
                        return getAverage(cc, l, tl, bl);
                }
        }

        //Kernel 3 and 7
        maxDark = max3(cc, l, t);
        minLight = min3(r, br, b);

        if (minLight > maxDark) {
                return getAverage(cc, r, br, b);
        } else {
                maxDark = max3(cc, r, b);
                minLight = min3(t, l, tl);
                if (minLight > maxDark) {
                        return getAverage(cc, t, l, tl);
                }
        }

        return cc;
}
