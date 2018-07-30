using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class GenerateTexture : MonoBehaviour {

    [Range(1, 14), Tooltip("Will be multiplied by 16")]
    public int size;
    public float noiseScale;

    [Range(1, 5)]
    public int numberOfOctaves;
    [Range(0, 1)]
    public float persistance;
    public float lacrunarity;

    public int seed;
    public Vector2 offset;

    public bool autoUpdate;

    Renderer rend;
    Texture2D texture;

    private void Awake()
    {
        rend = GetComponent<Renderer>();
    }

    // Use this for initialization
    void Start () {
        
    }

    public void UpdateTexture()
    {
        int chunk = size * 16;
        float[,] noiseMap = Noise.GenerateNoiseMap(chunk, chunk, seed, noiseScale, numberOfOctaves, persistance, lacrunarity, offset);
        texture = TextureGenerator.TextureFromHeightMap(noiseMap);
        GetComponent<Renderer>().sharedMaterial.mainTexture = texture;
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
