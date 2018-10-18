using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_IPHONE
using System.Runtime.InteropServices;
#endif

public class SaveDataInstanceCtrl  :MonoBehaviour{

	static SaveDataInstanceCtrl _instance;

	public static SaveDataInstanceCtrl instance{
		get{ 
		
			if (_instance == null) {
				GameObject go = new GameObject ();
				go.name = "SaveDataInstanceCtrl";
				go.transform.position = Vector3.zero;
				_instance = go.AddComponent<SaveDataInstanceCtrl> ();
			}
			return _instance;
		}
	}

	public void SaveData(string key,string value){
		SaveMyData (key,value);
	}

	public string GetDataByKey(string key){
		return GetMyData (key);
	}

	#if UNITY_IOS
	[DllImport("__Internal")]
	public static extern void SaveMyData(string key,string value);

	[DllImport("__Internal")]
	public static extern string GetMyData(string key);
	#endif
}
