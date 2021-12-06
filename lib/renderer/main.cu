// #define STB_IMAGE_IMPLEMENTATION
// #include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#include <iostream>
#include <cstdio>
#include <chrono>
#include <fstream>
#include <vector>
#include <sstream>
#include <random>
#include<nlohmann/json.hpp>
#include <unistd.h>  //Для getwd
#include <limits.h>  //Для PATH_MAX
#include <stdio.h>   //Для printf

using json = nlohmann::json;
using namespace std;

#define gpuErr(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess)
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

// __device__ int cols;
// __device__ int rows;

int cols1;
int rows1;

// int cols;
// int rows;

class vec2;
class vec3;
class vec4;

class vec2 {
public:
    __host__ __device__ vec2(){}
    __host__ __device__ vec2(float _t)
    : x(_t), y(_t) {}
    __host__ __device__ vec2(float _x, float _y)
    : x(_x), y(_y) {}
    float x = 0;
    float y = 0;
};

class vec4 {
public:
    __host__ __device__ vec4(){}
    // __host__ __device__ vec4()
    // : x(0), y(0), z(0), w(0) {}
    __host__ __device__ vec4(float _t)
    : x(_t), y(_t), z(_t), w(_t) {}
    __host__ __device__ vec4(float _x, float _y, float _z, float _w)
    : x(_x), y(_y), z(_z), w(_w) {}
    float x=0, y=0, z=0, w=0;
};

class vec3 {
public:
    __host__ __device__ vec3(){}
    __host__ __device__ vec3(float _t)
    : x(_t), y(_t), z(_t) {}

    __host__ __device__ vec3(vec4 vec){
        x = vec.x;
        y = vec.y;
        z = vec.z;
    }

    __host__ __device__ vec3(float _x, float _y, float _z)
    : x(_x), y(_y), z(_z) {}
    float x=0, y=0, z=0;
};

std::ostream& operator<< (std::ostream &out, const vec3 &vec)
{
    out << "vec3(" << vec.x << ", " << vec.y << ", " << vec.z << ")";
    return out;
}
std::ostream& operator<< (std::ostream &out, const vec2 &vec)
{
    out << "vec2(" << vec.x << ", " << vec.y << ")";
    return out;
}
std::ostream& operator<< (std::ostream &out, const vec4 &vec)
{
    out << "vec4(" << vec.x << ", " << vec.y << ", " << vec.z << ", " << vec.w << ")";
    return out;
}


__host__ __device__ vec2 fract(vec2 vec) {
    vec.x = modff(vec.x, &vec.x);
    vec.y = modff(vec.y, &vec.y);
    return vec;
}

__host__ __device__ vec3 fract(vec3 vec){
    vec.x = modff(vec.x, &vec.x);
    vec.y = modff(vec.y, &vec.y);
    vec.z = modff(vec.z, &vec.z);
    return vec;
}

__host__ __device__ vec4 fract(vec4 vec) {
    vec.x = modff(vec.x, &vec.x);
    vec.y = modff(vec.y, &vec.y);
    vec.z = modff(vec.z, &vec.z);
    vec.w = modff(vec.w, &vec.w);
    return vec;
}

__host__ __device__ float dot(vec4 _vec1, vec4 _vec2) {
    return _vec1.x*_vec2.x + _vec1.y*_vec2.y + _vec1.z*_vec2.z + _vec1.w*_vec2.w;
}

__host__ __device__ float dot(vec3 _vec1, vec3 _vec2) {
    return _vec1.x*_vec2.x + _vec1.y*_vec2.y + _vec1.z*_vec2.z;
}

__host__ __device__ float dot(vec2 _vec1, vec2 _vec2) {
    return _vec1.x*_vec2.x + _vec1.y*_vec2.y;
}


//////////

__host__ __device__ vec2 operator+ (vec2 _vec1, vec2 _vec2) {
    _vec1.x += _vec2.x;
    _vec1.y += _vec2.y;
    return _vec1;
}

__host__ __device__ vec2 operator- (vec2 _vec1, vec2 _vec2) {
    _vec1.x -= _vec2.x;
    _vec1.y -= _vec2.y;
    return _vec1;
}

__host__ __device__ vec2 operator* (vec2 _vec1, vec2 _vec2) {
    _vec1.x *= _vec2.x;
    _vec1.y *= _vec2.y;
    return _vec1;
}

__host__ __device__ vec2 operator/ (vec2 _vec1, vec2 _vec2) {
    _vec1.x /= _vec2.x;
    _vec1.y /= _vec2.y;
    return _vec1;
}

// --------- //

__host__ __device__ vec3 operator+ (vec3 _vec1, vec3 _vec2) {
    _vec1.x += _vec2.x;
    _vec1.y += _vec2.y;
    _vec1.z += _vec2.z;
    return _vec1;
}

__host__ __device__ vec3 operator- (vec3 _vec1, vec3 _vec2) {
    _vec1.x -= _vec2.x;
    _vec1.y -= _vec2.y;
    _vec1.z -= _vec2.z;
    return _vec1;
}

__host__ __device__ vec3 operator* (vec3 _vec1, vec3 _vec2) {
    _vec1.x *= _vec2.x;
    _vec1.y *= _vec2.y;
    _vec1.z *= _vec2.z;
    return _vec1;
}

__host__ __device__ vec3 operator/ (vec3 _vec1, vec3 _vec2) {
    _vec1.x /= _vec2.x;
    _vec1.y /= _vec2.y;
    _vec1.z /= _vec2.z;
    return _vec1;
}

// --------- //

__host__ __device__ vec4 operator+ (vec4 _vec1, vec4 _vec2) {
    _vec1.x += _vec2.x;
    _vec1.y += _vec2.y;
    _vec1.z += _vec2.z;
    _vec1.w += _vec2.w;
    return _vec1;
}

__host__ __device__ vec4 operator- (vec4 _vec1, vec4 _vec2) {
    _vec1.x -= _vec2.x;
    _vec1.y -= _vec2.y;
    _vec1.z -= _vec2.z;
    _vec1.w -= _vec2.w;
    return _vec1;
}

__host__ __device__ vec4 operator* (vec4 _vec1, vec4 _vec2) {
    _vec1.x *= _vec2.x;
    _vec1.y *= _vec2.y;
    _vec1.z *= _vec2.z;
    _vec1.w *= _vec2.w;
    return _vec1;
}

__host__ __device__ vec4 operator/ (vec4 _vec1, vec4 _vec2) {
    _vec1.x /= _vec2.x;
    _vec1.y /= _vec2.y;
    _vec1.z /= _vec2.z;
    _vec1.w /= _vec2.w;
    return _vec1;
}

// --------- //

__host__ __device__ vec3 operator+ (vec3 _vec1, float n) {
    _vec1.x += n;
    _vec1.y += n;
    _vec1.z += n;
    return _vec1;
}

__host__ __device__ vec3 operator+ (float n, vec3 _vec1) {
    _vec1.x += n;
    _vec1.y += n;
    _vec1.z += n;
    return _vec1;
}

__host__ __device__ vec3 operator- (vec3 _vec1, float n) {
    _vec1.x -= n;
    _vec1.y -= n;
    _vec1.z -= n;
    return _vec1;
}

__host__ __device__ vec3 operator- (float n, vec3 _vec1) {
    _vec1.x = n - _vec1.x;
    _vec1.y = n - _vec1.y;
    _vec1.z = n - _vec1.z;
    return _vec1;
}

__host__ __device__ vec3 operator* (vec3 _vec1, float n) {
    _vec1.x *= n;
    _vec1.y *= n;
    _vec1.z *= n;
    return _vec1;
}

__host__ __device__ vec3 operator* (float n, vec3 _vec1) {
    _vec1.x *= n;
    _vec1.y *= n;
    _vec1.z *= n;
    return _vec1;
}

__host__ __device__ vec3 operator/ (float n, vec3 _vec1) {
    _vec1.x = n / _vec1.x;
    _vec1.y = n / _vec1.y;
    _vec1.z = n / _vec1.z;
    return _vec1;
}

__host__ __device__ vec3 operator/ (vec3 _vec1, float n) {
    _vec1.x /= n;
    _vec1.y /= n;
    _vec1.z /= n;
    return _vec1;
}

// __device__ vec4 R_STATE;

std::vector<std::string> split(std::string s, char delimiter){
   std::vector<std::string> tokens;
   std::string token;
   std::istringstream tokenStream(s);
   while (std::getline(tokenStream, token, delimiter))
   {
      tokens.push_back(token);
   }
   return tokens;
}
/////////

__host__ __device__ vec3 abs(vec3 _vec1) {
    _vec1.x =  fabsf(_vec1.x);
    _vec1.y =  fabsf(_vec1.y);
    _vec1.z =  fabsf(_vec1.z);
    return _vec1;
}

__host__ __device__ vec3 sign(vec3 _vec1) {

    _vec1.x = (0 < _vec1.x) - (_vec1.x < 0);
    _vec1.y = (0 < _vec1.y) - (_vec1.y < 0);
    _vec1.z = (0 < _vec1.z) - (_vec1.z < 0);
    return _vec1;
}

/////////
class Mesh {
public:
    Mesh(){

    }

    void readFileWafefront2(string filename){
        ifstream file(filename);
        string str;
        while(getline(file, str)) {
            auto data = split(str, ' ');
            if (str == ""){
                break;
            }
            if (data[0] == "v"){
                vertices.push_back(vec3(std::stof(data[1]), std::stof(data[2]), std::stof(data[3])));
                // vertices.push_back(vec3(1, 2, 3));
                // vertices1.push_back(1);
            }

            if (data[0] == "vn"){
                normals.push_back(vec3(std::stof(data[1]), std::stof(data[2]), std::stof(data[3])));
            }

            if (data[0] == "f") {
                vector<int> idxs;
                vector<int> idxsn;
                for(int i = 1; i < data.size(); i++){
                    if (data[i] == " " || data[i] == "")
                        continue;
                    auto vec = split(data[i], '/');
                    // auto vec = split(data[i], '/');
                    idxs.push_back(std::stoi(vec[0]));
                    idxsn.push_back(std::stoi(vec[2]));
                }
                for (int i = 1; i < idxs.size()-1; i+=1) {
                    vec3 lol = vec3(idxs[0], idxs[i], idxs[i+1]);
                    indexes.push_back(lol);
                    indexesNormal.push_back(idxsn[i]);
                    // if(i == 1)
                }
            }
        }

        file.close();
    }

    void process(){
        vector<vec3> copyVertices;
        for (auto i : indexes) {

            copyVertices.push_back(vertices[int(i.x-1)]);
            copyVertices.push_back(vertices[int(i.y-1)]);
            copyVertices.push_back(vertices[int(i.z-1)]);
        }
        vertices = copyVertices;

        vector<vec3> copyNormals;
        for (auto i : indexesNormal) {

            copyNormals.push_back(normals[int(i-1)]);
            // copyNormals.push_back(vertices[int(i.y-1)]);
            // copyNormals.push_back(vertices[int(i.z-1)]);
            // copyNormals.push_back(vertices[int(i.)])
        }
        normals = copyNormals;

    }

    std::vector<int> indexesNormal;
    vector<vec3> normals;
    // std::vector<int> vertices1;
    std::vector<vec3> vertices;
    std::vector<vec3> indexes;
};

class DeviceModel{
public:
    int sizeVertices;
    vec3* normalsDevice;
    vec3* verticesDevice;
    vec3 position;
    vec4 color;
};

class Model{
public:
    Model(string filenameMesh, vec3 position, vec4 color){
        this->filenameMesh = filenameMesh;
        this->position = position;
        this->color = color;
    }
    Model(){}
    void loadModel(){
        mesh.readFileWafefront2(filenameMesh);
        mesh.process();
        normalsDevice = new vec3[mesh.vertices.size()/3];
        verticesDevice = new vec3[mesh.vertices.size()];
        this->sizeVertices = mesh.vertices.size();
        std::copy(&mesh.vertices[0], &mesh.vertices[sizeVertices], verticesDevice);
        std::copy(&mesh.normals[0], &mesh.normals[sizeVertices/3], normalsDevice);
        // std::copy(std::begin(&(mesh.normals[0])), std::end(&(mesh.normals[0])), std::begin(normalsDevice));
    }

    DeviceModel getDeviceModel(){
        DeviceModel dm;
        this->sizeModel = sizeof(int) + sizeVertices*sizeof(vec3) + sizeVertices/3*sizeof(vec3) + sizeof(vec3) + sizeof(vec4);
        dm.sizeVertices = this->sizeVertices;
        dm.normalsDevice = normalsDevice;
        dm.verticesDevice = verticesDevice;

        dm.position = position;
        dm.color = color;

        return dm;
    }

    int getSizeModel(){

        return sizeModel;
        // return sizeof(int) + this->sizeVertices*sizeof(vec3) + this->sizeVertices/3*sizeof(vec3);
    }

    vec3* normalsDevice;
    vec3* verticesDevice;
    int sizeVertices;
    int sizeModel;
    string filenameMesh;
    Mesh mesh;
    vec3 position;
    vec4 color;
};


json readJson(string filename){
    std::ifstream file(filename);
    json j;
    string jsonStr = "";

    while (file){
        string kek;
        file >> kek;
        jsonStr += kek;
    }
    file.close();
    j = json::parse(jsonStr);
    return j;
}



__device__ DeviceModel* modelsGlobal;
__device__ int numberModelsGlobal;
// __device__ vec4* color123;
// __device__ vec3* normal123;
// __device__ vec3* it1;
// __device__ vec3* its;
// __device__ int sizeVertices;
// __device__ vec3* normalsDevice;

////////

__host__ __device__ vec3 clamp(vec3 _vec1, float _min, float _max) {

    _vec1.x = fminf(fmaxf(_vec1.x, _min), _max);
    _vec1.y = fminf(fmaxf(_vec1.y, _min), _max);
    _vec1.z = fminf(fmaxf(_vec1.z, _min), _max);
    return _vec1;
}

__host__ __device__ vec3 cross(vec3 _vec1, vec3 _vec2) {

    float x = _vec1.y*_vec2.z - _vec1.z*_vec2.y;
    float y = _vec1.z*_vec2.x - _vec1.x*_vec2.z;
    float z = _vec1.x*_vec2.y - _vec1.y*_vec2.x;
    _vec1.x = x;
    _vec1.y = y;
    _vec1.z = z;
    return _vec1;
}

__host__ float norm3(float x, float y, float z){
    return sqrt(x*x+y*y+z*z);
}

__host__ __device__ vec3 normalize(vec3 _vec1) {

    #ifdef __CUDA_ARCH__
    // device implementation
        float l = norm3df(_vec1.x, _vec1.y, _vec1.z);

        _vec1.x = _vec1.x / l;
        _vec1.y = _vec1.y / l;
        _vec1.z = _vec1.z / l;
        return _vec1;
    #else
    // host implementation

        float l = norm3(_vec1.x, _vec1.y, _vec1.z);
        _vec1.x = _vec1.x / l;
        _vec1.y = _vec1.y / l;
        _vec1.z = _vec1.z / l;
        return _vec1;
    #endif
}

__host__ __device__ vec3 reflect(vec3 _vec1, vec3 n) {
    return _vec1 - 2.0f * dot(n, _vec1) * n;
}

__host__ __device__ vec3 refract(vec3 I, vec3 N, float eta) {
    float k = 1.0 - eta * eta * (1.0 - dot(N, I) * dot(N, I));
    vec3 R;
    if (k < 0.0)
        return R;
    else
        R = eta * I - (eta * dot(N, I) + sqrt(k)) * N;
    return R;
}

__host__ __device__ vec3 mix(vec3 _vec1, vec3 _vec2, float a) {
    return _vec1 * ( 1 - a ) + _vec2 * a;
}

///////////
__device__ void printVec(vec3 v){
    printf("%f, %f, %f\n", v.x, v.y, v.z);
}

__device__ void printVec(vec4 v){
    printf("%f, %f, %f %f\n", v.x, v.y, v.z, v.w);
}

__host__ __device__ vec2 sphIntersect(vec3 ro, vec3 rd, float ra) {
	float b = dot(ro, rd);
	float c = dot(ro, ro) - ra * ra;
	float h = b * b - c;
	if(h < 0.0) return vec2(-1.0);
	h = sqrt(h);
	return vec2(-b - h, -b + h);
}

__host__ __device__ float plaIntersect(vec3 ro, vec3 rd, vec4 p) {
	return -(dot(ro, vec3(p)) + p.w) / dot(rd, vec3(p));
}

__host__ __device__ vec3 getSky(vec3 rd) {
    vec3 light = normalize(vec3(-0.5, 0.75, -1.0));
	vec3 col = vec3(0.3, 0.6, 1.0);
	vec3 sun = vec3(0.95, 0.9, 1.0);
	sun = sun * fmaxf(0.0f, powf(dot(rd, light), 256.0f));
	col = col * fmaxf(0.0f, dot(light, vec3(0.0, 0.0, -1.0)));
	return clamp(sun + col * 0.01f, 0.0f, 1.0f);
}

__host__ __device__ unsigned int TausStep(unsigned int z, int S1, int S2, int S3, unsigned int M){
	unsigned int b = (((z << S1) ^ z) >> S2);
	return (((z & M) << S3) ^ b);
}

__host__ __device__ unsigned int LCGStep(unsigned int z, unsigned int A, unsigned int C){
	return (A * z + C);
}

__host__ __device__ vec2 hash22(vec2 p, vec2 seed1){
	p = p + seed1.x;
	vec3 p3 = fract(vec3(p.x, p.y, p.x) * vec3(.1031, .1030, .0973));
    // printVec(p3);
	p3 = p3 + dot(p3, vec3(p3.y, p3.z, p3.x) + 33.33f);
	return fract(( vec2(p3.x, p3.x) + vec2(p3.y, p3.z) ) * vec2(p3.z, p3.x));
}

__host__ __device__ float random1(vec4* R_STATE){
	R_STATE->x = TausStep(R_STATE->x, 13, 19, 12, (unsigned int)(4294967294));
	R_STATE->y = TausStep(R_STATE->y, 2, 25, 4, (unsigned int)(4294967288));
	R_STATE->z = TausStep(R_STATE->z, 3, 11, 17, (unsigned int)(4294967280));
	R_STATE->w = LCGStep(R_STATE->w, (unsigned int)(1664525), (unsigned int)(1013904223));
	return 2.3283064365387e-10 * float(((unsigned int)(R_STATE->x) ^ (unsigned int)(R_STATE->y) ^ (unsigned int)(R_STATE->z) ^ (unsigned int)(R_STATE->w)));
}

__host__ __device__ vec3 randomOnSphere(vec4* R_STATE) {
	vec3 rand = vec3(random1(R_STATE), random1(R_STATE), random1(R_STATE));
	float theta = rand.x * 2.0 * 3.14159265;
	float v = rand.y;
	float phi = acos(2.0 * v - 1.0);
	float r = pow(rand.z, 1.0 / 3.0);
	float x = r * sin(phi) * cos(theta);
	float y = r * sin(phi) * sin(theta);
	float z = r * cos(phi);
	return vec3(x, y, z);
}

__host__ __device__ vec3 triIntersect(vec3 ro, vec3 rd, vec3 v0, vec3 v1, vec3 v2) {
    vec3 v1v0 = v1 - v0;
    vec3 v2v0 = v2 - v0;
    vec3 rov0 = ro - v0;
    vec3  n = cross( v1v0, v2v0 );
    vec3  q = cross( rov0, rd );
    float d = 1.0/dot( rd, n );
    float u = d*dot( -1*q, v2v0 );
    float v = d*dot(  q, v1v0 );
    float t = d*dot( -1*n, rov0 );
    if( u<0.0 || u>1.0 || v<0.0 || (u+v)>1.0 ) t = -1.0;

    return vec3( t, u, v );
}

__host__ __device__ vec3 triangleNormal(vec3 v1, vec3 v2, vec3 v3){
    vec3 A = v1 - v2;
    vec3 B = v3 - v1;
    return normalize(cross( A, B ));
}

__global__ void castRayTriangles(vec3 ro, vec3 rd, vec4* color123) {
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    //
    // if (j > numberModelsGlobal-1 || i > modelsGlobal[j].sizeVertices){
    //     return;
    // }
    // if (i %3 != 0 || i == 0){
    //     return;
    // }
    //
    // // int count = 0;
    // vec3* norm = modelsGlobal[j].normalsDevice;
    // vec3* vert = modelsGlobal[j].verticesDevice;
    // vec3 triPos = modelsGlobal[j].position;
    // vec3 it1 = triIntersect(ro - triPos, rd, vert[i], vert[i+1], vert[i+2]);
    // vec3* its =
    *color123 = vec4(i, j, i, j);
    // if(it1.x > 0.0 && it1.x < 999) {
        // *color = modelsGlobal[j].color;
        // *normal = -1*norm[i/3];
    // }
}

__host__ __device__ vec4 castRay(vec3* ro, vec3* rd, vec4* R_STATE) {

    float MAX_DIST = 99;
	vec4 col;
	vec2 it;
	vec3 n;
    vec2 minIt = vec2(MAX_DIST);
    vec4 spheresPos[5];
    vec4 spheresColor[5];

	spheresPos[0] = vec4(0, 10, 0, 1);
	spheresPos[1] = vec4(0, -10, 0, 1);
	spheresPos[2] = vec4(10, 0, 0, 1);
	spheresPos[3] = vec4(-10, 0, 0, 1);
    // spheresPos[0] = vec4(2, 0, -1, 2);

	spheresColor[0] = vec4(0.9, 0.1, 0.1, 0.7);
	spheresColor[1] = vec4(0.1, 0.9, 0.1, 0.7);
	spheresColor[2] = vec4(0.1, 0.1, 0.9, 0.7);
	spheresColor[3] = vec4(0.9, 0.9, 0.1, 0.7);
    // spheresColor[0] = vec4(1., 1, 1, -2.0);

	for(int i = 0; i < 4; i++) {
		it = sphIntersect(*ro - vec3(spheresPos[i]), *rd, spheresPos[i].w);
		if(it.x > 0.0 && it.x < minIt.x) {
			minIt = it;
			vec3 itPos = *ro + *rd * it.x;
			n = normalize(itPos - vec3(spheresPos[i]));
			col = spheresColor[i];
		}
	}

    #ifdef __CUDA_ARCH__
    // int max_sizeVertices = 0;
    // for (size_t i = 0; i < numberModelsGlobal; i++) {
    //     if (modelsGlobal[i].sizeVertices > max_sizeVertices) {
    //         max_sizeVertices = modelsGlobal[i].sizeVertices;
    //     }
    // }
    //
    // dim3 grid(numberModelsGlobal, 32);
    // dim3 block(numberModelsGlobal/grid.x+1, max_sizeVertices/grid.y+1);
    // vec3 color;
    // // castRayTriangles<<<grid, block>>>(*ro, *rd);
    // vec4* color123 = new vec4;
    // castRayTriangles<<<grid, block>>>(*ro, *rd, color123);
    // cudaDeviceSynchronize();
    // // printVec(*color123);
    // delete color123;
    // col = *color;
    // n = *normal;
    // its = new vec3;
    // it.x = it1->x;
    // it.y = it1->y;
    for (int j = 0; j < numberModelsGlobal; j++) {
        int count = 0;
        vec3* norm = modelsGlobal[j].normalsDevice;
        vec3* vert = modelsGlobal[j].verticesDevice;
        for(int i = 0; i < modelsGlobal[j].sizeVertices; i+=3){
            vec3 triPos = modelsGlobal[j].position;
            // printf("%d \n", i);
            // printf("%f, %f, %f\n", verticesDevice[i].x, verticesDevice[i].y, verticesDevice[i].z);
            vec3 it1 = triIntersect(*ro - triPos, *rd, vert[i], vert[i+1], vert[i+2]);
            if(it1.x > 0.0 && it1.x < minIt.x) {
                minIt.x = it1.x;
                minIt.y = it1.y;
                it.x = it1.x;
                it.y = it1.y;
                col = modelsGlobal[j].color;
                n = -1*norm[count];
                // n = 1*triangleNormal(verticesDevice[i], verticesDevice[i+1], verticesDevice[i+2]);
            }
            count++;
        }
    }
    #else
    #endif

	vec3 planeNormal(0.0, 0.0, -1.0);
	it = vec2(plaIntersect(*ro, *rd, vec4(planeNormal.x, planeNormal.y, planeNormal.z, 1.0)));
	if(it.x > 0.0 && it.x < minIt.x) {
		minIt = it;
		n = planeNormal;
		col = vec4(0.5, 0.25, 0.1, 0.9);
	}

    // minIt = vec2(MAX_DIST);
	if(minIt.x == MAX_DIST) {
        vec3 temp =  getSky(*rd);
        return vec4(temp.x, temp.y, temp.z, -2.0f);
    }


	if(col.w == -2.0f)
        return col;

	vec3 reflected = reflect(*rd, n);

	if(col.w < 0.0f) {
		float fresnel = 1.0f - fabsf(dot(-1 * *rd, n));
		if(random1(R_STATE) - 0.1f < fresnel * fresnel) {
			*rd = reflected;
			return col;
		}
		*ro = *ro + *rd * (minIt.y + 0.001f);
		*rd = refract(*rd, n, 1.0f / (1.0f - col.w));
		return col;
	}

	vec3 itPos = *ro + *rd * it.x;
	vec3 r = randomOnSphere(R_STATE);

	vec3 diffuse = normalize(r * dot(r, n));
	*ro = *ro + *rd * (minIt.x - 0.001f);
	*rd = mix(diffuse, reflected, col.w);
	return col;
}

__host__ __device__ vec3 traceRay(vec3 ro, vec3 rd, vec4* R_STATE) {
	vec3 col(1.0f);
    // printVec(ro);
    float MAX_REF = 8;
    // vec3 *ro1 = new vec3(ro);
    // vec3 *rd1 = new vec3(rd);
    // printVec(*ro1, 0, 0);
	for(int i = 0; i < MAX_REF; i++)
	{
		vec4 refCol = castRay(&ro, &rd, R_STATE);
		col = col * vec3(refCol);
		if(refCol.w == -2.0f){
            // delete ro1;
            // delete rd1;
            return col;
        }
	}
    // delete ro1;
    // delete rd1;
	return vec3(0.0);
}
/////

__device__ char * my_strcpy(char *dest, const char *src){
  int i = 0;
  do {
    dest[i] = src[i];}
  while (src[i++] != 0);
  return dest;
}

__device__ char * my_strcat(char *dest, const char *src){
  int i = 0;
  while (dest[i] != 0) i++;
  my_strcpy(dest+i, src);
  return dest;
}
// Device code // main shader
__device__ vec4 rotate(float a) {
    float s = sinf(a);
    float c = cosf(a);
    return vec4(c, -s, s, c);
}

__host__ __device__ vec3 shader(vec2 pixelPosition, vec2 resolution, vec4 rayOrigin, vec3 partFrame, vec3 prevPartFrame, vec2 seed1, vec2 seed2, int numberFrames, vec2 u_mouse){
    vec2 uv = pixelPosition / (resolution / 2) - 1;
	vec2 uvRes = hash22(uv + 1.0f, seed1) * resolution + resolution;
    // vec2 uvRes;
    uv = vec2(uv.y, uv.x);
    vec4 R_STATE;
	R_STATE.x = (unsigned int)(seed1.x + uvRes.x);
	R_STATE.y = (unsigned int)(seed1.y + uvRes.x);
	R_STATE.z = (unsigned int)(seed2.x + uvRes.y);
	R_STATE.w = (unsigned int)(seed2.y + uvRes.y);
    // printVec(uvRes, 99, 99);

    vec3 rayDirection = normalize(vec3(rayOrigin.w, uv.x, uv.y));
    // vec3 rayDirection = vec3(-0.692740, 0.689188, 0.212440);
    float xd = (rayDirection.x*cosf(u_mouse.x))+(rayDirection.y*-sinf(u_mouse.x));
    float yd = (rayDirection.x*sinf(u_mouse.x))+(rayDirection.y*cosf(u_mouse.x));
    rayDirection.x = xd;
    rayDirection.y = yd;
    // float a = u_mouse.x;
    // float zd = (rayDirection.z*cosf(-a))+(rayDirection.x*-sinf(-a));
    // float xd = (rayDirection.z*sinf(-a))+(rayDirection.x*cosf(-a));
    // rayDirection.x = xd;
    // rayDirection.z = zd;

    // float b = 0.1;
    // float xd = (rayDirection.x*cosf(b))+(rayDirection.y*-sinf(b));
    // float yd = (rayDirection.x*sinf(b))+(rayDirection.y*cosf(b));
    // rayDirection.x = xd;
    // rayDirection.y = yd;
    // rayDirection = normalize(rayDirection);

    // #ifdef __CUDA_ARCH__
    // printVec(rayDirection);
    // #endif
	// rayDirection.x = rayDirection.x * rotate(u_mouse.x);
    // rayDirection.y = rayDirection.y * rotate(u_mouse.x);
    // rayDirection.zx *= rotate(-u_mouse.y);
	vec3 rayOrigin1 = vec3(rayOrigin);

	vec3 col(0.0f);
	int samples = 4;
	for(int i = 0; i < samples; i++) {
		col = col + traceRay(rayOrigin1, rayDirection, &R_STATE);
	}

	col = col / samples;
	float white = 20.0;
	col = col * white * 16.0;
	col = (col * (1.0f + col / white / white)) / (1.0f + col);
    if(col.x > 1){
        col.x = 1;
    }
    if(col.y > 1){
        col.y = 1;
    }
    if(col.z > 1){
        col.z = 1;
    }
    if (numberFrames != 1) {
        col = mix(prevPartFrame, col, 1.0f/numberFrames);
    }

    return col;
}

__device__ void itoa(int number, char* lol, int begin) {
    if(number == 0){
        lol[begin + 0] = '0';
        lol[begin + 1] = '0';
        lol[begin + 2] = '0';
        lol[begin + 3] = ';';
        return;
    }

    int i = 2;
    int part = 0;
    while(number != 0) {
        part = number % 10;
        lol[begin + i] = part + '0';
        number /= 10;
        i--;
    }
    for (i=i; i > 0; i--)
        lol[begin + i] = '0';

    lol[begin + 3] = ';';
}



__global__ void kernel(vec2 resolution, vec4 rayOrigin, vec3* frame, char* stringFrame, vec2 seed1, vec2 seed2, int numberFrame, DeviceModel* models, int numberModels, vec2 u_mouse) {
    int rows = blockIdx.x * blockDim.x + threadIdx.x;
    int cols = blockIdx.y * blockDim.y + threadIdx.y;
    // color123 = new vec4;
    // it1 = new vec3;
    // normal = new vec3;
    modelsGlobal = models;
    numberModelsGlobal = numberModels;


    // if(rows == 0 || cols == 0){
    //     printVec(models[0].position);
    // }

    vec3 partFrame;

    if (cols > int(resolution.y)-1 || rows > int(resolution.x)-1) {
        return;
    }
    vec2 pixelPosition(rows, cols);

    vec3 prevPartFrame = frame[rows* int(resolution.y) + cols];
    partFrame = shader(pixelPosition, resolution, rayOrigin, partFrame, prevPartFrame, seed1, seed2, numberFrame, u_mouse);
    frame[rows* int(resolution.y) + cols] = partFrame;

    //???
    // vec3 color = frame[rows* int(resolution.y) + cols] * 255;
    // int begin = rows * int(resolution.y)*20 + cols*20;
    // int numberColor = rows* int(resolution.y) + cols;
    //
    // stringFrame[begin + 0] = '\E';
    // stringFrame[begin + 1] = '[';
    // stringFrame[begin + 2] = '4';
    // stringFrame[begin + 3] = '8';
    // stringFrame[begin + 4] = ';';
    // stringFrame[begin + 5] = '2';
    // stringFrame[begin + 6] = ';';
    // itoa(int(color.x), stringFrame, begin+7);
    // itoa(int(color.y), stringFrame, begin+11);
    // itoa(int(color.z), stringFrame, begin+15);
    //
    // stringFrame[begin + 18] = 'm';
    // if(cols == resolution.y-1){
    //     stringFrame[begin + 19] = '\n';
    // } else {
    //     stringFrame[begin + 19] = ' ';
    // }

    // stringFrame[20*int(resolution.x)*int(resolution.y)] = '\0';

}


class Timer{
private:
	// Псевдонимы типов используются для удобного доступа к вложенным типам
	using clock_t = std::chrono::high_resolution_clock;
	using second_t = std::chrono::duration<double, std::ratio<1> >;

	std::chrono::time_point<clock_t> m_beg;

public:
	Timer() : m_beg(clock_t::now())
	{
	}

	void reset()
	{
		m_beg = clock_t::now();
	}

	double elapsed() const
	{
		return std::chrono::duration_cast<second_t>(clock_t::now() - m_beg).count();
	}
};

class Window {
public:
    Window(int width, int height, vec4 rayOrigin){
        resolution = vec2(width, height);
        this->rayOrigin = rayOrigin;
        sizeFrame = width * height;
        sizeFrameByte = sizeFrame * sizeof(vec3);
        u_mouse = vec2(0,0);
    }

    void loadModels(string _fileObjects) {
        this->fileObjects = _fileObjects;
        json js;

        bool flag = true;
        while(flag){
            try {
              js = readJson(_fileObjects);
              flag = false;
            } catch (...) {
              flag = true;
            }
        }

        numberModels = 0;
        models.clear();
        for (auto i: js){
            numberModels += 1;
            string filename  = i["mesh"];
            vec3 v1 = vec3(i["position"]["x"], i["position"]["y"], i["position"]["z"]);

            vec4 v2 = vec4(i["color"]["r"], i["color"]["g"], i["color"]["b"], i["color"]["a"]);
            Model model(filename, v1, v2);
            model.loadModel();
            models.push_back(model);
        }
    }

    void loadModelsToCuda() {
        int sizeModels = 0;
        DeviceModel dm;
        hostModels.clear();
        for(auto model : models){
            dm = model.getDeviceModel();
            sizeModels += model.getSizeModel();
            hostModels.push_back(dm);
        }

        gpuErr(cudaMalloc((void**)&deviceModels, sizeModels));
        vec3* verticesDevice;
        vec3* normalsDevice;
        // vec3* position;
        // vec4* color;
        for (size_t i = 0; i < numberModels; i++) {
            cudaMalloc((void**)&verticesDevice, hostModels[i].sizeVertices*sizeof(vec3));
            cudaMalloc((void**)&normalsDevice, hostModels[i].sizeVertices/3*sizeof(vec3));
            // cudaMalloc((void**)&position, sizeof(vec3));
            // cudaMalloc((void**)&color, sizeof(vec4));

            cudaMemcpy(verticesDevice, hostModels[i].verticesDevice, hostModels[i].sizeVertices*sizeof(vec3), cudaMemcpyHostToDevice);
            cudaMemcpy(normalsDevice, hostModels[i].normalsDevice, hostModels[i].sizeVertices/3*sizeof(vec3), cudaMemcpyHostToDevice);
            // cudaMemcpy(position, hostModels[i].verticesDevice, hostModels[i].sizeVertices*sizeof(vec3), cudaMemcpyHostToDevice);
            // cudaMemcpy(color, hostModels[i].normalsDevice,*sizeof(vec3), cudaMemcpyHostToDevice);

            cudaMemcpy(&(deviceModels[i].verticesDevice), &(verticesDevice), sizeof(deviceModels[i].verticesDevice), cudaMemcpyHostToDevice);
            cudaMemcpy(&(deviceModels[i].normalsDevice), &(normalsDevice), sizeof(deviceModels[i].normalsDevice), cudaMemcpyHostToDevice);
            cudaMemcpy(&(deviceModels[i].sizeVertices), &(hostModels[i].sizeVertices), sizeof(deviceModels[i].sizeVertices), cudaMemcpyHostToDevice);
            cudaMemcpy(&(deviceModels[i].position), &(hostModels[i].position), sizeof(deviceModels[i].position), cudaMemcpyHostToDevice);
            cudaMemcpy(&(deviceModels[i].color), &(hostModels[i].color), sizeof(deviceModels[i].color), cudaMemcpyHostToDevice);
        }
    }

    void init(){
        e2 = std::mt19937(rd());
        frame = new vec3[sizeFrame];
        cudaMalloc((void**)&deviceFrame, sizeFrameByte);
    }

    void render() {
        // u_mouse.x += 0.1;
        std::uniform_real_distribution<> dist(0.0f, 1.0f);
        seed1 = vec2((float)dist(e2), (float)dist(e2) * 999.0f);
        seed2 = vec2((float)dist(e2), (float)dist(e2) * 999.0f);
        dim3 grid(32, 32);
        dim3 block(resolution.x/grid.x+1, resolution.y/grid.y+1);
        kernel<<<grid, block>>>(resolution, rayOrigin, deviceFrame, deviceStringFrame, seed1, seed2, n, deviceModels, numberModels, u_mouse);
        n++;
        gpuErr(cudaMemcpy(frame, deviceFrame, sizeFrameByte, cudaMemcpyDeviceToHost));
    }

    void framePrepare(){
        stringFrame = "";
        for (int i = 0; i < resolution.x; i++) {
            for (int j = 0; j < resolution.y; j++) {
                vec3 color = frame[i*int(resolution.y) + j];
                color = (color * 255.0f);
                // if(color.x > 255){
                //     color.x = 240;
                // }
                // if(color.y > 255){
                //     color.y = 240;
                // }
                // if(color.z > 255){
                //     color.z = 240;
                // }
                // char* img

                stringFrame +=  "\e[48;2;" + to_string(int(color.x)) + ";"
                                     + to_string(int(color.y)) + ";"
                                     + to_string(int(color.z)) + "m ";
            }
            stringFrame += "\n";
        }
    }

    void outputFrame(){
        std::cout << flush;
        std::cout << "\e[1;1H";
        std::cout << stringFrame << endl;
    }

    void outputFrameFile(){
        ofstream file("lib/pipe/image", std::ofstream::out | std::ofstream::trunc);
        file << stringFrame << "\n";
        file.close();
    }

    void getCommand(){
        string command;
        string command2;
        ifstream filer("lib/pipe/command");
        filer >> command;
        filer >> command2;
        filer.close();
        if (command != ""){
            n = 1;


            if(command == "left") {
                u_mouse.x =std::stof(command2);
            }

            if(command == "right") {
                u_mouse.x =std::stof(command2);
            }

            if(command == "up") {
                float x = std::cos(u_mouse.x);
                float y = std::sin(u_mouse.x);

                rayOrigin = rayOrigin + vec4(x, y, 0, 0);
            }

            if(command == "down") {
                float x = std::cos(u_mouse.x);
                float y = std::sin(u_mouse.x);

                rayOrigin = rayOrigin - vec4(x, y, 0, 0);
            }

            if(command == "position") {
                json js = readJson(fileObjects);
                int index = 0;
                for (auto i: js) {
                    hostModels[index].position = vec3(i["position"]["x"], i["position"]["y"], i["position"]["z"]);
                    index ++;
                }
                for (size_t i = 0; i < numberModels; i++) {
                    cudaMemcpy(&(deviceModels[i].position), &(hostModels[i].position), sizeof(deviceModels[i].position), cudaMemcpyHostToDevice);
                }
            }

            cudaFree(deviceModels);
            loadModels(fileObjects);
            loadModelsToCuda();

            if(command == "color") {
                json js = readJson(fileObjects);
                int index = 0;
                for (auto i: js) {
                    hostModels[index].color = vec4(i["color"]["r"], i["color"]["g"], i["color"]["b"], i["color"]["a"]);
                    index ++;
                }
                for (size_t i = 0; i < numberModels; i++) {
                    cudaMemcpy(&(deviceModels[i].color), &(hostModels[i].color), sizeof(deviceModels[i].color), cudaMemcpyHostToDevice);
                }
            }

            if(command == "exit") {
                cudaFree(deviceModels);
                cudaFree(deviceStringFrame);
                cudaFree(deviceFrame);
                delete [] frame;
                // command = "";
                ofstream filew2("lib/pipe/command", std::ofstream::out | std::ofstream::trunc);
                filew2.close();
                exit(0);
            }

            command = "";
            ofstream filew("lib/pipe/command", std::ofstream::out | std::ofstream::trunc);
            filew.close();
        }
    }

    ~Window(){
        cudaFree(deviceModels);
        cudaFree(deviceStringFrame);
        cudaFree(deviceFrame);
        delete [] frame;
    }

    void renderPicture(string filename){
        int n = 0;
        int x = resolution.x;
        int y = resolution.y;

        char* imge = new char[x*y*3];
        for (size_t i = 0; i < x; i++) {
            for (size_t j = 0; j < y; j+=1) {
                vec3 v = frame[i * y + j]*255.0f;
                if (v.x > 255) {
                    v.x = 255;
                }
                if (v.y > 255) {
                    v.y = 255;
                }
                if (v.z > 255) {
                    v.z = 255;
                }
                imge[n] = v.x;
                imge[n+1] = v.y;
                imge[n+2] = v.z;
                n+=3;
            }
        }

        stbi_write_jpg(filename.c_str(), x, y, 3, imge, 100);
    }

int n = 1;
vec2 u_mouse;
vector<Model> models;
DeviceModel* deviceModels;
int numberModels;

vector<DeviceModel> hostModels;

string fileObjects;
string stringFrame;
char* deviceStringFrame;
vec3* frame;
vec3* deviceFrame;
int sizeFrame;
int sizeFrameByte;
vec2 seed1;
vec2 seed2;
std::random_device rd;
std::mt19937 e2;

vec4 rayOrigin;
vec2 resolution;

};

int main(){

    vec4 rayOrigin(0, 0, 0, 1);
    int x = 50;
    int y = 50*2.6;
    Window window(x, y, rayOrigin);
    window.init();
    window.loadModels("lib/pipe/enemies.json");
    window.loadModelsToCuda();


    while(true){
    // for (size_t i = 0; i < 1; i++) {
        window.render();
        window.framePrepare();
        window.outputFrameFile();
        // window.outputFrame();
        window.getCommand();
    }

    return 0;
}


















//
