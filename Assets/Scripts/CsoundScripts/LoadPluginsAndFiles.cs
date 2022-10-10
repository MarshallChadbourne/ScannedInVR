using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Csound.LoadPlugins
{
    public class LoadPluginsAndFiles : MonoBehaviour
    {
        [Tooltip("The names of the plugins to copy from Resources to the Persistent Data Path folder. " +
            "Don't specify the extension. In this example will be added the extension to the copied files depending on the platform")]
        [SerializeField] private string[] _pluginsNamesNames;
        [SerializeField] private AdditionalFileInfo[] _additionalFiles;

        [Tooltip("Ensure this CsoundUnity GameObject is inactive when hitting play, " +
            "otherwise the CsoundUnity initialization will run. " +
            "Setting the Environment Variables on a running Csound instance can have unintended effects.")]
        public CsoundUnity CsoundUnity;

        // Start is called before the first frame update
        void Start()
        {
            foreach (var pluginName in _pluginsNamesNames)
            {
                var dir = Application.persistentDataPath;
                //if (!Directory.Exists(dir))
                //    Directory.CreateDirectory(dir);
                var pluginPath = string.Empty;

                var destinationPath = string.Empty;
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
                destinationPath = Path.Combine(dir, pluginName + ".dll");
                pluginPath = Path.Combine("Win", pluginName);
#elif UNITY_EDITOR_OSX || UNITY_STANDALONE_OSX || UNITY_IOS
                
                destinationPath = Path.Combine(dir, "lib" + pluginName + ".dylib");
                pluginPath = Path.Combine("MacOS", "lib" + pluginName);
#elif UNITY_ANDROID
                destinationPath = Path.Combine(dir, pluginName + ".jni");
                pluginPath = Path.Combine("Android", pluginName);
#endif
                if (!File.Exists(destinationPath))
                {
                    Debug.Log($"Loading plugin at path: {pluginPath}");
                    var plugin = Resources.Load<TextAsset>(pluginPath);
                    Debug.Log($"Writing plugin file at path: {destinationPath}");
                    Stream s = new MemoryStream(plugin.bytes);
                    BinaryReader br = new BinaryReader(s);
                    using (BinaryWriter bw = new BinaryWriter(File.Open(destinationPath, FileMode.OpenOrCreate)))
                    {
                        bw.Write(br.ReadBytes(plugin.bytes.Length));
                    }
                }
            }

            foreach (var additionalFile in _additionalFiles)
            {
                var dir = Path.Combine(Application.persistentDataPath, additionalFile.Directory);
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);
                var destinationPath = Path.Combine(dir, additionalFile.FileName + additionalFile.Extension);
                if (!File.Exists(destinationPath))
                {
                    var af = Resources.Load<TextAsset>(additionalFile.FileName);
                    Debug.Log($"Writing additional file at path: {destinationPath}");
                    Stream s = new MemoryStream(af.bytes);
                    BinaryReader br = new BinaryReader(s);
                    using (BinaryWriter bw = new BinaryWriter(File.Open(destinationPath, FileMode.OpenOrCreate)))
                    {
                        bw.Write(br.ReadBytes(af.bytes.Length));
                    }
                }
            }

            // activate CsoundUnity!
            CsoundUnity.gameObject.SetActive(true);
        }

        [Serializable]
        public class AdditionalFileInfo
        {
            public string Directory;
            public string FileName;
            public string Extension;
        }
    }
}