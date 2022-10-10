using System.IO;
using UnityEngine;

namespace Csound.EnvironmentVars
{
    public class Initializer_Alternative_Plugins : MonoBehaviour
    {
        [Tooltip("The names of the plugin files to copy from Resources to the Persistent Data Path folder. " +
            "Don't specify the extension. In this example will be added the '.dylib' extension to the copied files.")]
        [SerializeField] private string[] _pluginsNames;
        [Tooltip("Ensure this CsoundUnity GameObject is inactive when hitting play, " +
            "otherwise the CsoundUnity initialization will run. " +
            "Setting the Environment Variables on a running Csound instance can have unintended effects.")]
        public CsoundUnity CsoundUnity;

        // Start is called before the first frame update
        void Start()
        {
            foreach (var pluginName in _pluginsNames)
            {
                var dir = Path.Combine(Application.persistentDataPath, "CsoundFiles");
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                var destinationPath = Path.Combine(dir, pluginName + ".dylib");
                if (!File.Exists(destinationPath))
                {
                    
                    var plugin = Resources.Load<TextAsset>(pluginName);
                    Debug.Log(plugin);
                    Debug.Log($"Writing plugin file at path: {destinationPath}");
                    Stream s = new MemoryStream(plugin.bytes);
                    BinaryReader br = new BinaryReader(s);
                    using (BinaryWriter bw = new BinaryWriter(File.Open(destinationPath, FileMode.OpenOrCreate)))
                    {
                        bw.Write(br.ReadBytes(plugin.bytes.Length));
                    }
                }
            }
            // activate CsoundUnity!
            CsoundUnity.gameObject.SetActive(true);
        }
    }
}
