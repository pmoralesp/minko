package aerys.minko.scene.material
{
	import aerys.minko.query.IScene3DQuery;
	import aerys.minko.query.rendering.RenderingQuery;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	/**
	 * The MovieClipMaterials3D enables using MovieClip objects as texture data.
	 * 
	 * MovieClipMaterial3D objects makes it easy to use animated materials and
	 * provides an interface similar to the MovieClip class with methods such
	 * as "gotoAndPlay", "play" or "gotoAndStop".
	 * 
	 * The source MovieClip frames are uploaded to the GPU when required.
	 * Because each MovieClip only has a limited number of frames, each frame
	 * will be upload once and only once. Thus, modifying the MovieClip during
	 * or after upload will give unpredicted results.
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class MovieClipMaterial3D extends AnimatedMaterial3D
	{
		private var _source			: MovieClip			= null;
		private var _currentFrame	: int				= 1;
		private var _playing		: Boolean			= true;
		
		private var _frames			: Vector.<Boolean>	= new Vector.<Boolean>();
		
		public function get isPlaying() : Boolean	{ return _playing; }
		
		public function MovieClipMaterial3D(source : MovieClip)
		{
			super();
			
			_source = source;
			_source.gotoAndStop(0);
		}
		
		override protected function nextFrame(query : RenderingQuery) : void
		{
			if (_source && _playing)
			{
				if (!_frames[int(_currentFrame - 1)])
				{
					_frames[int(_currentFrame - 1)] = true;
					
					var mat : BitmapMaterial3D = BitmapMaterial3D.fromDisplayObject(_source);
					
					mat.name = _source.currentFrameLabel;
					
					addChild(mat);
					_source.gotoAndStop(_currentFrame++);
					
					if (numChildren == _source.totalFrames)
						_source = null;
				}
			}
			
			super.nextFrame(query);
		}
		
		public function stop() : void
		{
			_playing = false;
		}
		
		public function play() : void
		{
			_playing = true;
		}
		
		public function gotoAndPlay(frame : Object) : void
		{
			_source.gotoAndStop(frame);
			_playing = true;
		}
		
		public function gotoAndStop(frame : Object) : void
		{
			_source.gotoAndStop(frame);
			_playing = false;
		}
	}
}