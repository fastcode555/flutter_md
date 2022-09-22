/// @date 16/9/22
/// describe:
class EditActionModel {
  static const int insert = 0;

  ///粗体
  static const int bold = 2;

  ///斜体
  static const int italic = 3;

  ///下滑线
  static const int underline = 4;

  ///删除线
  static const int lineThrough = 5;

  ///增加文字标签
  static const int font = 6;

  ///增加文本的背景颜色
  static const int background = 7;

  ///插入链接的功能
  static const int insertLink = 8;

  ///插入图片的功能
  static const int insertImage = 9;

  ///插入分割符
  static const int insertDelimiter = 10;

  ///页面进行分屏
  static const int splitScreen = 20;

  ///页面进支持展示
  static const int justShow = 21;

  ///保存
  static const int save = 30;

  ///另存为
  static const int saveAs = 31;

  ///选中的文本内容
  String? content;

  ///描述
  String? description;

  int action;

  EditActionModel({this.content, this.description, this.action = EditActionModel.insert});
}
