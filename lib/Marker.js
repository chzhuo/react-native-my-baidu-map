import React, {Component} from 'react';
import {requireNativeComponent, View, Platform} from 'react-native';
import PropTypes from 'prop-types';
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';

const {NODE_ENV} = process.env;
const isIos = Platform.OS === 'ios';
const isDev = NODE_ENV === 'development';

export default class Marker extends Component {
  static propsTypes = {
    ...View.propTypes,
    /**
     *标题
     */
    title: PropTypes.string,
    /**
     *坐标
     */
    location: PropTypes.shape({
      latitude: PropTypes.number.isRequired,
      longitude: PropTypes.number.isRequired,
    }),
    /**
     *图片
     */
    icon: PropTypes.string,
    /**
     * 是否可拖拽
     */
    draggable: PropTypes.bool,
    /**
     * 是否显示infowind,
     */
    active: PropTypes.bool,
    /**
     * 设置marker层级
     */
    zIndex: PropTypes.number,
    /**
     * infowind y轴偏移
     */
    infoWindowYOffset: PropTypes.number,
    /**
     * icon缩放大小, 仅android
     */
    scale: PropTypes.number,
    /**
     * 是否开启近大远小效果, 仅android
     */
    perspective: PropTypes.bool,
    /**
     * 透明度, 仅android
     */
    alpha: PropTypes.number,
    /**
     * 旋转角度, 仅android
     */
    rotate: PropTypes.number,
    /**
     * 是否平贴地图, 仅android
     */
    flat: PropTypes.bool,
    /**
     * infoWindow 最小高度, 仅android
     */
    infoWindowMinHeight: PropTypes.number,
    /**
     * infoWindow 最小宽度, 仅android
     */
    infoWindowMinWidth: PropTypes.number,
    /**
     * infoWindow 字体, 仅android
     */
    infoWindowTextSize: PropTypes.number,
  };

  static defaultProps = {
    title: '',
    location: {
      latitude: 0,
      longitude: 0,
    },
    icon: '',
    perspective: false,
    alpha: 1,
    rotate: 0,
    zIndex: 0,
    scale: isDev ? 1 : 0.5,
    flat: false,
    draggable: false,
    active: false,
    infoWindowYOffset: 0,
    infoWindowMinHeight: 100,
    infoWindowMinWidth: 200,
    infoWindowTextSize: 16,
  };

  render() {
    let icon;
    if (this.props.icon) {
      icon = resolveAssetSource(this.props.icon) || {};
      icon = isIos
        ? icon.uri || this.props.icon
        : icon.uri
        ? icon
        : {uri: this.props.icon};
    }
    return <BaiduMapOverlayMarker {...this.props} icon={icon} />;
  }
}

const BaiduMapOverlayMarker = requireNativeComponent('RCTMarkerView', Marker);
