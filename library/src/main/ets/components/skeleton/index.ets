import { CONTAINER_SIZE } from "../../theme-chalk/src/container"

@Component
export struct IBestSkeleton{
    private uiContext: UIContext = this.getUIContext()
    @Builder linerBg(){
        Row()
            .width(CONTAINER_SIZE.FULL)
            .height(CONTAINER_SIZE.FULL)
            .linearGradient({
                direction: GradientDirection.Right,
                colors: [['#303030', 0.25], ['#424243', 0.37], ['#303030', 0.63]]
            })
    }
    keyframeAnimateTo() {
        // this.uiContext.keyframeAnimateTo({ iterations: -1 }, [
        //     {
        //         // 第一段关键帧动画时长为100ms
        //         duration: 100,
        //         curve: Curve.Ease,
        //         event: () => {
        //
        //         }
        //     },
        //     {
        //         // 第一段关键帧动画时长为700ms
        //         duration: 700,
        //         curve: Curve.Ease
        //         event: () => {
        //
        //         }
        //     }
        // ])
    }
    build() {
        Row()
            .width(CONTAINER_SIZE.FULL)
            .height(40)
            .background(this.linerBg)
            .backgroundImageSize({width: '400%', height: '100%'})
            .backgroundImagePosition({x: "100%", y: '50%'})
            .onAppear(() => {
                this.keyframeAnimateTo()
            })
    }
}

@Component
export struct IBestSkeletonTitle{
    build() {

    }
}