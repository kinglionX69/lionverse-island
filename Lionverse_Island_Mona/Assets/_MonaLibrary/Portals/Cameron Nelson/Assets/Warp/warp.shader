// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33325,y:32669,varname:node_3138,prsc:2|emission-7219-RGB;n:type:ShaderForge.SFN_Fresnel,id:1483,x:32660,y:32620,varname:node_1483,prsc:2|EXP-6205-OUT;n:type:ShaderForge.SFN_SceneColor,id:7219,x:32877,y:32946,varname:node_7219,prsc:2|UVIN-411-OUT;n:type:ShaderForge.SFN_NormalVector,id:4664,x:32131,y:32450,prsc:2,pt:False;n:type:ShaderForge.SFN_Negate,id:2767,x:32315,y:32450,varname:node_2767,prsc:2|IN-4664-OUT;n:type:ShaderForge.SFN_Transform,id:3485,x:32487,y:32450,varname:node_3485,prsc:2,tffrom:1,tfto:3|IN-2767-OUT;n:type:ShaderForge.SFN_ComponentMask,id:2669,x:32660,y:32450,varname:node_2669,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-3485-XYZ;n:type:ShaderForge.SFN_ScreenPos,id:2845,x:32485,y:32991,varname:node_2845,prsc:2,sctp:2;n:type:ShaderForge.SFN_Add,id:411,x:32694,y:32946,varname:node_411,prsc:2|A-2318-OUT,B-2845-UVOUT;n:type:ShaderForge.SFN_Multiply,id:2318,x:33234,y:32453,varname:node_2318,prsc:2|A-2669-OUT,B-9853-OUT;n:type:ShaderForge.SFN_Slider,id:6205,x:32315,y:32689,ptovrint:False,ptlb:Fresnel exponent,ptin:_Fresnelexponent,varname:node_6205,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2,max:10;n:type:ShaderForge.SFN_OneMinus,id:9615,x:32818,y:32620,varname:node_9615,prsc:2|IN-1483-OUT;n:type:ShaderForge.SFN_Power,id:2854,x:32972,y:32620,varname:node_2854,prsc:2|VAL-9615-OUT,EXP-5071-OUT;n:type:ShaderForge.SFN_Slider,id:5071,x:32318,y:32825,ptovrint:False,ptlb:node_5071,ptin:_node_5071,varname:node_5071,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:6,max:10;n:type:ShaderForge.SFN_Clamp01,id:9853,x:33169,y:32620,varname:node_9853,prsc:2|IN-2854-OUT;proporder:6205-5071;pass:END;sub:END;*/

Shader "Shader Forge/warp" {
    Properties {
        _Fresnelexponent ("Fresnel exponent", Range(0, 10)) = 2
        _node_5071 ("node_5071", Range(0, 10)) = 6
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _Fresnelexponent)
                UNITY_DEFINE_INSTANCED_PROP( float, _node_5071)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float4 projPos : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
////// Emissive:
                float _Fresnelexponent_var = UNITY_ACCESS_INSTANCED_PROP( Props, _Fresnelexponent );
                float _node_5071_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_5071 );
                float3 emissive = tex2D( _GrabTexture, ((UnityObjectToViewPos( float4((-1*i.normalDir),0) ).xyz.rgb.rg*saturate(pow((1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fresnelexponent_var)),_node_5071_var)))+sceneUVs.rg)).rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
