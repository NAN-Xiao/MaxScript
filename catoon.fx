//UNITY_MATRIX_MVP
float4x4 WvpXf : WorldViewProjection < string UIWidget = "None"; > ;

//unity_ObjectToWorld
float4x4 WorldXf : World < string UIWidget = "None"; > ;
//世界空间向量转换
float4x4 WorldITXf : WorldInverseTranspose < string UIWidget = "None"; > ;

//UNITY_MATRIX_MV
float4x4 WvXf : WorldView < string UIWidget = "None"; > ;
//View空间向量转换
float4x4 WvITXf : WorldViewInverseTranspose < string UIWidget = "None"; > ;

//UNITY_MATRIX_T_MV
float4x4 ViewIXf : ViewInverse < string UIWidget = "None"; > ;
//UNITY_MATRIX_IT_MV
float4x4 ViewITXf : ViewInverseTranspose < string UIWidget = "None"; > ;

//UNITY_MATRIX_V
float4x4 ViewXf : View < string UIWidget = "None"; > ;
//UNITY_MATRIX_P
float4x4 ProjectionXf : Projection < string UIWidget = "None"; > ;


// 世界空间 光源方向
float3 lightDir : Direction < string UIName = "Light Direction"; string Object = "TargetLight"; > = { -0.577, -0.577, 0.577 };

// 基础纹理
Texture2D <float4> g_BaseColorTexture < string UIName = "BaseColor"; string ResourceType = "2D"; int Texcoord = 0; int MapChannel = 1; > ;

SamplerState g_BaseColorSampler
{
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
	AddressV = Wrap;
};

// 漫反射基础属性
float g_DiffusSmoothUp <
	string UIName = "DiffusSmoothUp";
	string UIWidget = "slider";
	float UIMin = -1.00f;
	float UIMax = 1.00f;
	float UIStep = 0.001f;
> = 1.00f;

float g_DiffusSmoothDown <
	string UIName = "DiffusSmoothDown";
	string UIWidget = "slider";
	float UIMin = -1.00f;
	float UIMax = 1.00f;
	float UIStep = 0.001f;
> = 0.00f;

// 高光基础属性
float g_glossiness <
	string UIName = "Glossiness";
	string UIWidget = "slider";
	float UIMin = 0.00f;
	float UIMax = 10.00f;
	float UIStep = 0.001f;
> = 8.00f;

// 高光Smooth上限
float g_glossSmoothUp <
	string UIName = "GlossSmoothUp";
	string UIWidget = "slider";
	float UIMin = 0.00f;
	float UIMax = 1.00f;
	float UIStep = 0.001f;
> = 0.855f;

// 高光Smooth下限
float g_glossSmoothDown <
	string UIName = "GlossSmoothDown";
	string UIWidget = "slider";
	float UIMin = 0.00f;
	float UIMax = 1.00f;
	float UIStep = 0.001f;
> = 0.786f;

// 高光强度
float g_specularStrength <
	string UIName = "SpecularStrength";
	string UIWidget = "slider";
	float UIMin = 0.10f;
	float UIMax = 1.00f;
	float UIStep = 0.001f;
> = 0.70f;

// 描边宽度
float g_edgeThickness <
	string UIName = "EdgeThickness";
	string UIWidget = "slider";
	float UIMin = 0.0001f;
	float UIMax = 0.2f;
	float UIStep = 0.00001f;
> = 0.003f;


// light intensity
float4 I_a = { 0.3f, 0.3f, 0.3f, 1.0f };
float4 I_d = { 1.0f, 1.0f, 1.0f, 1.0f };
float4 I_s = { 0.6f, 0.6f, 0.6f, 1.0f };

// material reflectivity
float4 k_a < string UIName = "BackColor"; > = float4(0.2f, 0.2f, 0.2f, 1.0f);    //暗面颜色
float4 k_d < string UIName = "FrontColor"; > = float4(1.0f, 0.7f, 0.2f, 1.0f);    //亮面颜色
float4 k_s < string UIName = "EdgeColor"; > = float4(1.0f, 1.0f, 1.0f, 1.0f);    //描边颜色

// 顶点数据
struct appdata
{
	float4 Position		: POSITION;
	float3 Normal		: NORMAL;
	float3 Tangent		: TANGENT;
	float3 Binormal		: BINORMAL;
	float2 UV0		: TEXCOORD0;
	float3 Colour		: TEXCOORD1;
	float3 Alpha		: TEXCOORD2;
	float3 Illum		: TEXCOORD3;
	float3 UV1		: TEXCOORD4;
	float3 UV2		: TEXCOORD5;
	float3 UV3		: TEXCOORD6;
	float3 UV4		: TEXCOORD7;
};

// 像素数据
struct vertexOutput
{
	float4 HPosition	: SV_Position;
	float4 UV0		: TEXCOORD0;
	float3 LightVec	: TEXCOORD1;
	float3 WorldNormal	: TEXCOORD2;
	float3 WorldView	: TEXCOORD5;
	float4 UV1		: TEXCOORD6;
	float4 UV2		: TEXCOORD7;
	float4 wPos		: TEXCOORD8;
};

// 顶点着色器
vertexOutput std_VS(appdata IN)
{
	vertexOutput OUT = (vertexOutput)0;

	OUT.WorldNormal = mul(IN.Normal, WorldITXf).xyz;
	float4 Po = float4(IN.Position.xyz, 1);
	float3 Pw = mul(Po, WorldXf).xyz;
	OUT.LightVec = lightDir;// (Lamp0Pos - Pw);
	OUT.WorldView = normalize(ViewIXf[3].xyz - Pw);
	OUT.HPosition = mul(Po, WvpXf);
	OUT.wPos = mul(IN.Position, WorldXf);

	// Pass through the UVs
	OUT.UV0.xy = IN.UV0.xy;
	OUT.UV1.xy = IN.UV1.xy;
	OUT.UV2.xyz = IN.UV2.xyz;

	// UV bindings
	float4 colour;
	colour.rgb = IN.Colour * IN.Illum;
	colour.a = IN.Alpha.x;
	OUT.UV0.z = colour.r;
	OUT.UV0.a = colour.g;
	OUT.UV1.z = colour.b;
	OUT.UV1.a = colour.a;

	return OUT;
}

// 像素着色器
float4 std_PS(vertexOutput IN) : SV_Target
{
	// 采样纹理
	float4 baseColor = g_BaseColorTexture.Sample(g_BaseColorSampler,IN.UV0.xy);

	// 基本属性
	float3 Vn = normalize(IN.WorldView);
	float3 Nn = normalize(IN.WorldNormal);
	float3 Ln = normalize(IN.LightVec);
	float3 Hn = normalize(Ln + Vn);

	float NdH = dot(Nn, Hn);
	float NdL = dot(Nn, Ln);

	// 漫反射
	float4 diffuse = smoothstep(g_DiffusSmoothDown, g_DiffusSmoothUp, NdL);
	diffuse = lerp(k_a, k_d, diffuse);

	// 高光
	float specularIntensity = pow(NdH, g_glossiness * g_glossiness);
	float specularIntensitySmooth = smoothstep(g_glossSmoothDown, g_glossSmoothUp, specularIntensity);
	float4 specular = specularIntensitySmooth;

	//最终输出：
	float4 finalCol = baseColor * diffuse + specular * g_specularStrength;

	return float4(finalCol.rgb,1);
}


//外描边顶点着色器
vertexOutput std_VS_OutLine(appdata IN)
{
	vertexOutput OUT = (vertexOutput)0;

	// UV bindings
	float4 colour;
	colour.rgb = IN.Colour;
	colour.a = IN.Alpha.x;

	// float3 view_vertex = mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, float4(v.vertex, 1.0))).xyz;
	float3 view_vertex = mul(mul(float4(IN.Position.xyz, 1.0), WorldXf), ViewXf).xyz;

	// float3 view_normal = mul(UNITY_MATRIX_IT_MV, float4(v.normal, 0.0));
	float3 view_normal = mul(float4(IN.Normal, 0.0), WvITXf);

	view_vertex.xyz += normalize(view_normal) * g_edgeThickness;
	OUT.HPosition = mul(float4(view_vertex, 1.0), ProjectionXf);


	OUT.WorldNormal = mul(IN.Normal, WorldITXf).xyz;
	float4 Po = float4(IN.Position.xyz, 1);
	float3 Pw = mul(Po, WorldXf).xyz;
	OUT.LightVec = lightDir;// (Lamp0Pos - Pw);
	OUT.WorldView = normalize(ViewIXf[3].xyz - Pw);
	OUT.wPos = mul(IN.Position, WorldXf);

	// Pass through the UVs
	OUT.UV0.xy = IN.UV0.xy;
	OUT.UV1.xy = IN.UV1.xy;
	OUT.UV2.xyz = IN.UV2.xyz;

	return OUT;
}

//外描边像素着色器
float4 std_PS_OutLine(vertexOutput IN) : SV_Target
{
	return k_s;
}


RasterizerState DataCulling
{
	FillMode = SOLID;
	CullMode = FRONT;
	FrontCounterClockwise = false;
};

// 函数声明
fxgroup dx11
{
	technique11 Main_11 < string Script = "Pass=p0;"; >
	{
		pass p0 < string Script = "Draw=geometry;"; >
		{
			SetVertexShader(CompileShader(vs_5_0,std_VS()));
			SetGeometryShader(NULL);
			SetPixelShader(CompileShader(ps_5_0,std_PS()));
		}

		pass p1 < string Script = "Draw=outLine;"; >
		{
			SetRasterizerState(DataCulling);
			SetVertexShader(CompileShader(vs_4_0, std_VS_OutLine()));
			SetGeometryShader(NULL);
			SetPixelShader(CompileShader(ps_4_0, std_PS_OutLine()));
		}
	}
}

fxgroup dx10
{
	technique10 Main_10 < string Script = "Pass=p0;"; >
	{
		pass p0 < string Script = "Draw=geometry;"; >
		{
			SetVertexShader(CompileShader(vs_4_0,std_VS()));
			SetGeometryShader(NULL);
			SetPixelShader(CompileShader(ps_4_0,std_PS()));
		}

		pass p1 < string Script = "Draw=outLine;"; >
		{
			SetRasterizerState(DataCulling);
			SetVertexShader(CompileShader(vs_4_0, std_VS_OutLine()));
			SetGeometryShader(NULL);
			SetPixelShader(CompileShader(ps_4_0, std_PS_OutLine()));
		}
	}
}