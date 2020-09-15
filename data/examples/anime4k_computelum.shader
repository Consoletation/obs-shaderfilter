// Anime4K shader
// with help from StealthCT
// https://github.com/Anime4K/Anime4K
uniform string notes = "Step1";

float4 mainImage(VertData v_in) : TARGET
{
        float4 c0 = image.Sample(textureSampler, v_in.uv);

        //Quick luminance approximation
        float lum = (c0[0] + c0[0] + c0[1] + c0[1] + c0[1] + c0[2]) / 6;

        //Computes the luminance and saves it in the unused alpha channel
        return float4(c0[0], c0[1], c0[2], lum);
}
