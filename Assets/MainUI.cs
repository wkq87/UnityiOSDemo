using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainUI : MonoBehaviour {

	public Button SaveBtn;
	public Button GetBtn;

	public InputField inputText;
	public Text outText;

	// Use this for initialization

	void Start () {
		SaveBtn.onClick.AddListener (() => {

			string key = "wkq";
			string value = inputText.text.ToString();

			Debug.LogError("key = " + key + ",value = " + value);
			SaveDataInstanceCtrl.instance.SaveData(key,value);
			Debug.LogError("save success");
		});

		GetBtn.onClick.AddListener (() => {

			string key = "wkq";
			string value = SaveDataInstanceCtrl.instance.GetDataByKey(key);
			Debug.LogError("value = " + value);
			outText.text = value;
		});
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
